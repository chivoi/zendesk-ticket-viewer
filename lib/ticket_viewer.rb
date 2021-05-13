require 'httparty'
require 'json'
require 'terminal-table'

class TicketViewer
  attr_reader :username, :password, :subdomain, :auth

  def initialize(username, subdomain, password)
    @username = username
    @password = password
    @subdomain = subdomain
    @auth = {username: @username, password: @password}
  end

  def get_tickets()
    HTTParty.get("https://#{@subdomain}.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: @auth).parsed_response
  end

  def display_data(data)
    rows = []
    data["tickets"].each do |ticket|
      rows << ["ID: #{ticket["id"]}", "SUBJECT: #{ticket["subject"]}", ticket["status"].capitalize]
    end
    Terminal::Table.new :rows => rows
  end

  def turn_page(response, requested_page)
    requested_page_url = response["links"]["#{requested_page}"]
    HTTParty.get(requested_page_url, basic_auth: @auth).parsed_response
  end

  def get_single_ticket(data, id)
    ticket = data.select{|ticket| ticket["id"] == id}
    return ticket[0]
  end

  def display_ticket_data(ticket)
    rows = []
    rows << ["TICKET # #{ticket["id"]}", " "]
    rows << [" ", " "]
    rows << ["From", ticket["requester_id"]]
    rows << ["Status", ticket["status"]]
    rows << ["Priority", ticket["priority"]]
    rows << ["Created at", ticket["created_at"]]
    rows << ["Subject", ticket["subject"]]
    Terminal::Table.new :rows => rows
  end

end