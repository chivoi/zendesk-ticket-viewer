require_relative "../lib/ticket_viewer"
require 'dotenv'

Dotenv.load('.env')

describe 'TicketViewer' do
  before(:each) do
    @session = TicketViewer.new(ENV["EMAIL"], ENV["SUBDOMAIN"], ENV["PASSWORD"])
    @data = @session.get_tickets()
  end

  it "should be an instance of TicketViewer" do
    expect(@session).to be_a TicketViewer
  end
  it "should initialize with username and password" do
    expect(@session.username).to eq("a.lastovirya@gmail.com")
    expect(@session.subdomain).to eq("ana4256")
  end

  describe('get_tickets') do
    it 'should get a hash with an array of tickets that is not empty' do
      expect(@session.get_tickets()).to include("tickets")
    end
  end

  describe('single_ticket') do
    it 'should return the correct ticket' do
      id = 1
      ticket = @session.get_single_ticket(@data["tickets"], id)
      expect(ticket["id"]).to eq(1)
    end
  end

  describe('display_page') do
    it 'should return a table' do
      expect(@session.display_data(@data)).to be_a Terminal::Table
    end
  end
end