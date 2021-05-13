require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'
require 'tty-prompt'
require 'dotenv'

Dotenv.load('.env')

# variables
programme_start_prompt = TTY::Prompt.new
prompt = TTY::Prompt.new
pages_prompt = TTY::Prompt.new

puts "ZENDESK TICKET VIEWER\n"

# login logic
login_choices = [
  {name: "Default account", value: 1},
  {name: "My account (input credentials)", value: 2}
]
which_account = programme_start_prompt.select("\nLogin with default account or your personal account? ", login_choices, symbols: { marker: "->" })
case which_account
when 1
  # pull details from .env file
  session = TicketViewer.new(ENV["EMAIL"], ENV["SUBDOMAIN"], ENV["PASSWORD"])
  tickets = session.get_tickets  
when 2
  # input user's credentials 
  username = prompt.ask("Enter your email: ") do |q|
    q.required true
    q.validate :email
    q.modify   :downcase, :strip
  end
  user_subdomain = prompt.ask("Enter your subdomain name: ") do |q|
    q.required true
    q.modify :downcase, :strip
  end
  pwd = prompt.mask("Enter your password: ")
  # start a session with password
  session = TicketViewer.new(username, user_subdomain, pwd)
  tickets = session.get_tickets()
end

sleep(0.3)
puts "Working ..."
sleep(0.3)

# main programme loop
begin
  loop do
    raise GeneralError if tickets["tickets"].nil?
    # system "clear"
    puts session.display_data(tickets)

    # next and previous pages
    if tickets["meta"]["has_more"]
      paging_choices = [
        {name: "VIEW A TICKET", value: 1},
        {name: "NEXT PAGE", value: 2},
        {name: "PREV PAGE", value: 3},
        {name: "QUIT PROGRAM", value: 4},
      ]
      answer = pages_prompt.select("\n ", paging_choices, symbols: { marker: "->" })
      
      case answer
      when 1
        # handling errors in case of invalid input of ticket ID
        begin
          ticket_id = prompt.ask("Type in ticket ID: ")
          ticket = session.get_single_ticket(tickets["tickets"], ticket_id.to_i)
          if ticket_id.nil? || !ticket_id.scan(/\D/).empty?
            raise TypeError
          elsif ticket_id.to_i < tickets["tickets"].first["id"].to_i || ticket_id.to_i > tickets["tickets"].last["id"].to_i
            raise IDValidationError
          end
        rescue => e
          puts "Got a #{e.class} : #{e.message}"
        retry
        end
        system "clear"
        puts session.display_ticket_data(ticket)
        puts ticket["description"]
        single_ticket_choices = [
          {name: "BACK TO ALL TICKETS", value: 1},
          {name: "QUIT PROGRAM", value: 2}
        ]
        go_back = prompt.select("\n ", single_ticket_choices, symbols: { marker: "->" })
        case go_back
        when 1
          next
        when 2
          sleep(0.3)
          puts "Thank you for using Ticket Viewer. Have a great day!"
          break
        end
      when 2
        tickets = session.turn_page(tickets, "next")
      when 3
        tickets = session.turn_page(tickets, "prev")
      when 4
        sleep(0.3)
        puts "Thank you for using Ticket Viewer. Have a great day!"
        break
      end
    else
      last_page_choices = [
        {name: "BACK TO PAGE 1", value: 1},
        # {name: "BACK TO PREVIOUS PAGE", value: 2},
        {name: "QUIT PROGRAM", value: 3}
      ]
      last_page_answer = prompt.select("\n No more pages beyond this point!", last_page_choices, symbols: { marker: "->" })
      case last_page_answer
      when 1
        tickets = session.get_tickets
      # when 2
      #   tickets = session.turn_page(tickets, "prev")
      when 3
        sleep(0.3)
        puts "Thank you for using Ticket Viewer. Have a great day!"
        break
      end
    end  
  end
rescue => e
  puts e.message
end