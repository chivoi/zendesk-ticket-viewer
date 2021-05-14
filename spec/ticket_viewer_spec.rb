require_relative "../lib/ticket_viewer"
require_relative "../lib/errors"

require 'httparty'
require 'dotenv'

Dotenv.load('.env')

describe 'TicketViewer' do
  before(:each) do
    @session = TicketViewer.new(ENV["EMAIL"], ENV["SUBDOMAIN"], ENV["PASSWORD"])
    @response = HTTParty.get("https://#{@session.subdomain}.zendesk.com/api/v2/tickets.json?page[size]=25", basic_auth: @session.auth)
    @data = @session.get_tickets
  end

  # General initialize testing
  it "should be an instance of TicketViewer" do
    expect(@session).to be_a TicketViewer
  end
  it "should initialize with username and password" do
    expect(@session.username).to eq("a.lastovirya@gmail.com")
    expect(@session.subdomain).to eq("ana4256")
  end

  # Testing API responses

  describe ('API call and response') do
    it "should be successful with valid link and auth" do
      expect(@response.code).to eq(200)
    end

    it 'should return maximum 25 tickets at a time' do
      expect(@response.parsed_response.length).to be < 25
    end

    it "should contain tickets array" do
      expect(@response.parsed_response).to have_key("tickets")
    end

    it "should be successful with valid link and auth" do
      expect(@response.code).to eq(200)
    end

    it "should throw error when authentication fails" do
      failed_auth = HTTParty.get("https://#{@session.subdomain}.zendesk.com/api/v2/tickets.json", basic_auth: {username: "test@email.com", password: "1234"})
      unauthorized_user = TicketViewer.new("test@test.com", ENV["SUBDOMAIN"], "1234")
      expect(failed_auth.code).to eq(401)
      expect{unauthorized_user.get_tickets}.to raise_error(AuthorizationError)
    end
  end

  # Testing TicketViewer methods

  describe('get_tickets') do
    it 'should get a hash with an array of tickets that is not empty when called for the first time for an account that has tickets' do
      expect(@session.get_tickets["tickets"]).not_to be_empty
    end
  end

  describe('get_single_ticket') do
    it 'should return the correct ticket' do
      id = 1
      ticket = @session.get_single_ticket(@data["tickets"], id)
      expect(ticket["id"]).to eq(1)
    end
  end

  describe('display_data') do
    it 'should return a table' do
      expect(@session.display_data(@data)).to be_a Terminal::Table
    end
    it 'should throw General error if passed nil' do
      expect{@session.display_data("Hi")}.to raise_error(GeneralError)
    end
  end

  describe('display_ticket_data') do
    it 'should return a table' do
      expect(@session.display_ticket_data(@data["tickets"][0])).to be_a Terminal::Table
    end
  end

  describe('turn_page') do
    it 'should return differrent page' do
      expect(@session.turn_page(@data, "next")).not_to eq(@data)
    end
    it 'should return the correct page when called with next' do
      expect(@session.turn_page(@data, "next")["tickets"][0]["id"]).to eq(@data["tickets"].last["id"] + 1)
    end
    it 'should return the correct page when called with prev' do
      second_page = @session.turn_page(@data, "next")
      expect(@session.turn_page(second_page, "prev")["tickets"].last["id"]).to eq(second_page["tickets"].first["id"]-1)
    end
  end
end