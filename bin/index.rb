require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'
require 'tty-prompt'
require 'dotenv'

# load .env file
Dotenv.load('.env')

# prompts
programme_start_prompt = TTY::Prompt.new
prompt = TTY::Prompt.new
main_prompt = TTY::Prompt.new

system "clear"
puts "[ZENDESK TICKET VIEWER]\n"

begin
  # start the programme
  programme_start_prompt.select(" ", [{name: "Hit ENTER to start the programme", value: 1}], help: " ")
  session = TicketViewer.new(ENV["EMAIL"], ENV["SUBDOMAIN"], ENV["PASSWORD"])
  tickets = session.get_tickets

  # main programme loop

  loop do
    sleep(0.3)
    puts "Working ..."
    sleep(0.3)
    system "clear"

    puts session.display_data(tickets)

    # see if there are more pages
    if tickets["meta"]["has_more"]
      choices = [
        {name: "VIEW A TICKET", value: 1},
        {name: "NEXT PAGE >>", value: 2},
        {name: "PREV PAGE <<", value: 3},
        {name: "QUIT PROGRAM", value: 4},
      ]
      answer = main_prompt.select(" ", choices, help: " ")
      
      case answer
      when 1
        # search tickets to view by ID
        ticket_id = prompt.ask("Type in ticket ID: ") do |q|
          q.required true
          # validation and error handling for invalid input
          q.validate(/^\d+$/) # just the digits
          q.messages[:valid?] = "Invalid input. Ticket ID must be a positive integer (ex. 1, 15, 24)"
          q.in "#{tickets["tickets"].first["id"].to_i}-#{tickets["tickets"].last["id"].to_i}" # validates the ticket id range
          q.messages[:range?] = "This Ticket ID is not on this page. Please try a differrent ID. Or page."
        end
        ticket = session.get_single_ticket(tickets["tickets"], ticket_id.to_i)
        system "clear"
        puts session.display_ticket_data(ticket)
        puts "\n" + ticket["description"]
        single_ticket_choices = [
          {name: "BACK TO ALL TICKETS", value: 1},
          {name: "QUIT PROGRAM", value: 2}
        ]
        go_back = prompt.select(" ", single_ticket_choices, help: " ")
        case go_back
        when 1
          # go onto next loop iteration => output all tickets
          next
        when 2
          break
        end
      when 2
        # display next page
        tickets = session.turn_page(tickets, "next")
      when 3
        # display prev page
        tickets = session.turn_page(tickets, "prev")
      when 4
        break
      end
    else
      # if "prev page" clicked on the first page, clears screen for cleaner UI 
      if tickets["tickets"].length < 1 
        system "clear"
        last_page_choices = [
          {name: "BACK TO PAGE 1", value: 2},
          {name: "QUIT PROGRAM", value: 3}
        ]
      else
      # keeping view ticket option for the last page
        last_page_choices = [
          {name: "VIEW A TICKET", value: 1},
          {name: "BACK TO PAGE 1", value: 2},
          {name: "QUIT PROGRAM", value: 3}
        ]
      end
      # if last (or only) page, notifies user and offers to go back or quit
      last_page_answer = prompt.select("\n No more pages beyond this point!\n", last_page_choices, help: " ")
      case last_page_answer
      when 1
         # single ticket view flow, last minute bug, this could be refactored
         ticket_id = prompt.ask("Type in ticket ID: ") do |q|
          q.required true
          q.validate(/^\d+$/)
          q.messages[:valid?] = "Invalid characters. Ticket ID must be a positive integer (ex. 1, 15, 24)"
          q.in "#{tickets["tickets"].first["id"].to_i}-#{tickets["tickets"].last["id"].to_i}"
          q.messages[:range?] = "This Ticket ID is not on this page. Please try a differrent ID. Or page."
        end
        ticket = session.get_single_ticket(tickets["tickets"], ticket_id.to_i)
        system "clear"
        puts session.display_ticket_data(ticket)
        puts "\n" + ticket["description"]
        single_ticket_choices = [
          {name: "BACK TO ALL TICKETS", value: 1},
          {name: "QUIT PROGRAM", value: 2}
        ]
        go_back = prompt.select(" ", single_ticket_choices, help: " ")
        case go_back
        when 1
          next
        when 2
          break
        end
      when 2
        tickets = session.get_tickets
      when 3
        break
      end
    end  
  end
rescue => e
  puts "Error: #{e.message}"
end

# when the user chooses to quit, this message is displayed
sleep(0.3)
puts "Thank you for using Ticket Viewer. Have a great day!"