require_relative "../lib/ticket_viewer"
require 'json'

describe 'TicketViewer' do
  before(:each) do
    @ticket_viewer = TicketViewer.new("test@email.com", "1234", "company567")
    @response = File.read(File.expand_path("../../test-docs/tickets.json", __FILE__))
    @data = JSON.parse(@response)["tickets"]
  end

  it "should be an instance of TicketViewer" do
    expect(@ticket_viewer).to be_a TicketViewer
  end
  it "should initialize with username and password" do
    expect(@ticket_viewer.username).to eq("test@email.com")
    expect(@ticket_viewer.password).to eq("1234")
    expect(@ticket_viewer.subdomain).to eq("company567")
  end

  describe('all_tickets') do
    it 'should get an error when authentication fails' do
      expect(@ticket_viewer.get_tickets).to include("error")
    end
  end

  # TODO: Testing actual HTTP responses

  describe('single_ticket') do
    it 'should return the correct ticket' do
      id = 1
      ticket = @ticket_viewer.single_ticket(@data, id)
      expect(ticket[0]["assignee_id"]).to eq(5)
    end
  end

  describe('display_page') do
    it 'should return a table' do
      expect(@ticket_viewer.display_page(@data)).to be_a Terminal::Table
    end
  end


end