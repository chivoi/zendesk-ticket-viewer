require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'

puts "ZENDESK TICKET VIEWER\n"
puts "Enter your email: "
username = gets.strip

puts "Enter your password: "
password = gets.strip

puts "Enter your subomain name: "
subdomain = gets.strip

session = TicketViewer.new(username, password, subdomain)

sleep(0.3)
puts "Working ..."
sleep(0.3)

system "clear"
puts "YOUR TICKETS:"

tickets = session.get_tickets

# pagination loop
loop do
  puts session.display_data(tickets["tickets"])

  if tickets["meta"]["has_more"]
    puts "\ntype NEXT for next page, PREV for prev page"
    input = gets.strip.downcase
    if input == "next"
      system "clear"
      tickets = session.turn_page(tickets, "next")
    elsif input == "prev"
      system "clear"
      tickets = session.turn_page(tickets, "prev")
    end
  else 
    puts "THAT'S THE LAST PAGE!"
    break
  end
end