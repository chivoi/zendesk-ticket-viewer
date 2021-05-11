require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'
require 'tty-prompt'

puts "ZENDESK TICKET VIEWER\n"
puts "Enter your email: "
username = gets.strip

puts "Enter your password: "
password = gets.strip

# variables
session = TicketViewer.new(username, password)
notice = Pastel.new.bright_magenta.detach
prompt = TTY::Prompt.new(active_color: notice)
pages_prompt = TTY::Prompt.new(active_color: notice)

sleep(0.3)
  puts "Working ..."
  sleep(0.3)
  tickets = session.get_tickets

# main programme loop
loop do
  system "clear"
  choices = session.display_data(tickets)
  answer = prompt.select("YOUR TICKETS", choices, symbols: { marker: "~" })

  # THIS WORKS ONLY FOR THE FIRST 25
  if answer == 26  
    if tickets["meta"]["has_more"]
      paging_choices = [
        {name: "NEXT PAGE", value: 1},
        {name: "PREV PAGE", value: 2},
        {name: "QUIT PROGRAM", value: 3},
      ]
      answer = pages_prompt.select("\nWhere to next?", paging_choices, symbols: { marker: "~" })
      
      case answer
      when 1
        tickets = session.turn_page(tickets, "next")
      when 2
        tickets = session.turn_page(tickets, "prev")
      when 3
        sleep(0.3)
        puts "Thank you for using Ticket Viewer. Have a great day!"
        break
      end
    end
  else
    ticket = session.get_single_ticket(tickets["tickets"], answer)
    puts session.display_ticket_data(ticket)
    puts ticket["description"]
    go_back = prompt.yes?("\nBack to all tickets")
    break if !go_back
  end  
end