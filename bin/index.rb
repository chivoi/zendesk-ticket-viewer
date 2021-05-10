require_relative '../lib/ticket_viewer'
require_relative '../lib/errors'

puts "ZENDESK TICKET VIEWER\n"
puts "Enter your email: "
username = gets.strip

puts "Enter your password: "
password = gets

puts "Enter your subomain name: "
subdomain = gets.strip

sleep(0.3)
puts "Working ..."
sleep(0.3)

system "clear"
puts "YOUR TICKETS:"

session = TicketViewer.new(username, password, subdomain)

session.all_tickets()

