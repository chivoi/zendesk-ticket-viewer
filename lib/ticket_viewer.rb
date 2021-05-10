require 'httparty'
require 'json'

class TicketViewer
  attr_reader :username, :password, :subdomain

  def initialize(username, password, subdomain)
    @username = username
    @password = password
    @subdomain = subdomain
    @auth = {username: @username, password: @password}
  end

  def next_page(response, requested_page)
    requested_page_url = response["links"]["#{requested_page}"]
    HTTParty.get(requested_page_url, basic_auth: @auth).parsed_response["tickets"]
  end

  def all_tickets()
    HTTParty.get("https://#{@subdomain}.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: @auth).parsed_response
  end

  def single_ticket(data, requester_id)
    data.select{|ticket| ticket["requester_id"] == requester_id}
  end

end