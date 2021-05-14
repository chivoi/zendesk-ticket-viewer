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
    response = HTTParty.get("https://#{@subdomain}.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: @auth)
    # handling Auth and services not available range errors
    case response.code
    when 401
      raise AuthorizationError
    when 500..526
      raise UnavailableError
    end
    response.parsed_response
  end

  def display_data(data)
    raise GeneralError if data["tickets"].nil?
    rows = []
    data["tickets"].each do |ticket|
      rows << ["ID: #{ticket["id"]}", "SUBJECT: #{ticket["subject"]}", ticket["status"].capitalize]
    end
    Terminal::Table.new :rows => rows
  end

  def turn_page(response, requested_page)
    requested_page_url = response["links"][requested_page]
    HTTParty.get(requested_page_url, basic_auth: @auth).parsed_response
  end

  def get_single_ticket(data, id)
    ticket = data.select{|ticket| ticket["id"] == id}
    return ticket[0]
  end

  def display_ticket_data(ticket)
    rows = []
    rows << ["Status", ticket["status"]]
    rows << ["Priority", ticket["priority"]]
    rows << ["Created at", ticket["created_at"]]
    rows << ["Subject", ticket["subject"]]
    Terminal::Table.new :title => "TICKET # #{ticket["id"]}", :rows => rows
  end

end