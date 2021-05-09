require 'httparty'
require 'json'

class TicketViewer
  attr_reader :username, :password, :subdomain

  def initialize(username, password, subdomain)
    @username = username
    @password = password
    @subdomain = subdomain
  end

  def all_tickets()
    auth = {username: @username, password: @password}
    response = HTTParty.get("https://#{@subdomain}.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: auth).parsed_response["tickets"]
  end

end