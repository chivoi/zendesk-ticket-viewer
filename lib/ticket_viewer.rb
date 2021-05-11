require 'httparty'
require 'json'
require 'terminal-table'
require 'tty-prompt'

class TicketViewer
  attr_reader :username, :password, :subdomain

  def initialize(username, password)
    @username = username
    @password = password
    @auth = {username: @username, password: @password}
  end

  def turn_page(response, requested_page)
    requested_page_url = response["links"]["#{requested_page}"]
    HTTParty.get(requested_page_url, basic_auth: @auth).parsed_response
  end

  def get_tickets()
    HTTParty.get("https://ana4256.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: @auth).parsed_response
  end

  def get_single_ticket(data, id)
    ticket = data.select{|ticket| ticket["id"] == id}
    return ticket[0]
  end

  def display_ticket_data(ticket)
    rows = []
    rows << ["TICKET # #{ticket["id"]}"]
    rows << [" ", " "]
    rows << ["Priority", ticket["priority"]]
    rows << ["Subject", ticket["subject"]]
    rows << ["Status", ticket["status"]]

    Terminal::Table.new :rows => rows
  end

  def display_data(data)
    choices = []
    i = 0
    data["tickets"].each do |ticket|
      choices << {name: "ID: #{ticket["id"]} / PRIORITY: #{ticket["priority"]} | SUBJECT: #{ticket["subject"]} | STATUS:  #{ticket["status"]}", value: i+=1}
    end
    choices << {name: "MORE", value: 26}
    return choices
  end

end