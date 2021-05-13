require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'
require 'tty-prompt'
require 'dotenv'

Dotenv.load('.env')

# variables
programme_start_prompt = TTY::Prompt.new
prompt = TTY::Prompt.new
pages_prompt = TTY::Prompt.new

system "clear"
puts "ZENDESK TICKET VIEWER"
puts "___"

# login logic
begin
  login_choices = [
    {name: "DEFAULT", value: 1},
    {name: "MY ACCOUNT (input credentials)", value: 2}
  ]
  which_account = programme_start_prompt.select("\nLogin with default account or your personal account? ", login_choices, help: " ")
  case which_account
  when 1
    # pull details from .env file
    session = TicketViewer.new(ENV["EMAIL"], ENV["SUBDOMAIN"], ENV["PASSWORD"])
    tickets = session.get_tickets  
  when 2
    # input user's credentials 
    username = prompt.ask("ENTER YOUR EMAIL: ") do |q|
      q.required true
      q.validate :email
      q.messages[:valid?] = "Please enter a valid email address. Example: email@test.com"
      q.modify   :down, :strip
    end
    user_subdomain = prompt.ask("ENTER YOUR SUBDOMAIN NAME: ") do |q|
      q.required true
      q.modify :down, :strip
    end
    pwd = prompt.mask("ENTER YOUR PASSWORD: ")
    # start a session with password
    session = TicketViewer.new(username, user_subdomain, pwd)
    tickets = session.get_tickets()
  end

  # main programme loop

  loop do
    sleep(0.3)
    puts "Working ..."
    sleep(0.3)
    system "clear"

    puts session.display_data(tickets)

    # next and previous pages
    if tickets["meta"]["has_more"]
      paging_choices = [
        {name: "VIEW A TICKET", value: 1},
        {name: "NEXT PAGE >>", value: 2},
        {name: "PREV PAGE <<", value: 3},
        {name: "QUIT PROGRAM", value: 4},
      ]
      answer = pages_prompt.select("\n ", paging_choices, help: " ")
      
      case answer
      when 1
        ticket_id = prompt.ask("Type in ticket ID: ") do |q|
          q.required true
          # validation and error handling for invalid input
          q.validate(/^\d+$/) # validates just the digits
          q.messages[:valid?] = "Invalid characters. Ticket ID must be a positive integer (ex. 1, 15, 24)"
          q.in "#{tickets["tickets"].first["id"].to_i}-#{tickets["tickets"].last["id"].to_i}" # validates the ticket id range
          q.messages[:range?] = "This Ticket ID is not on this page. Please try a differrent ID."
        end
        ticket = session.get_single_ticket(tickets["tickets"], ticket_id.to_i)
        system "clear"
        puts session.display_ticket_data(ticket)
        puts ticket["description"]
        single_ticket_choices = [
          {name: "BACK TO ALL TICKETS", value: 1},
          {name: "QUIT PROGRAM", value: 2}
        ]
        go_back = prompt.select("\n ", single_ticket_choices, help: " ")
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
      system "clear" if tickets["tickets"].length < 1
      last_page_choices = [
        {name: "BACK TO PAGE 1", value: 1},
        # {name: "BACK TO PREVIOUS PAGE", value: 2},
        {name: "QUIT PROGRAM", value: 2}
      ]
      last_page_answer = prompt.select("\n No more pages beyond this point!", last_page_choices, help: " ")
      case last_page_answer
      when 1
        tickets = session.get_tickets
      when 2
        sleep(0.3)
        puts "Thank you for using Ticket Viewer. Have a great day!"
        break
      end
    end  
  end
rescue => e
  puts "Error: #{e.message}"
end