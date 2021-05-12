require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'
require 'tty-prompt'

# variables
notice = Pastel.new.bright_magenta.detach
prompt = TTY::Prompt.new(active_color: notice)
pages_prompt = TTY::Prompt.new(active_color: notice)

puts "ZENDESK TICKET VIEWER\n"

username = prompt.ask("Enter your email: ") do |q|
  q.required true
  q.validate(/^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$/, "Invalid email address")
  q.modify   :downcase, :strip
end
password = prompt.mask("Enter your password: ")

# starting a session
session = TicketViewer.new(username, password)
tickets = session.get_tickets

sleep(0.3)
puts "Working ..."
sleep(0.3)

# main programme loop
loop do
  system "clear"
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
      ticket_id = prompt.ask("Type in an ID of the ticket: ")
      ticket = session.get_single_ticket(tickets["tickets"], ticket_id.to_i)
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