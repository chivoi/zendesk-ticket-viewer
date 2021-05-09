require 'httparty'

class TicketViewer
  attr_reader :username, :password, :subdomain

  def initialize(username, password, subdomain)
    @username = username
    @password = password
    @subdomain = subdomain
  end

  def all_tickets()
    auth = {username: @username, password: @password}
    HTTParty.get("https://#{@subdomain}.zendesk.com/api/v2/tickets.json", basic_auth: auth).parsed_response["tickets"]
  end

end
