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

# print out all tickets
puts session.get_tickets

# check if there are more pages
if response["meta"]["has_more"]
  puts "\ntype NEXT for next page, PREV for prev page"
  input = gets.strip.downcase
  if input == "next"
    system "clear"
    puts next_page(response, "next")
  elsif input == "prev"
    system "clear"
    puts next_page(response, "prev")
  end
end