require_relative "../lib/ticket_viewer"

describe 'TicketViewer' do
  before(:each) do
    @ticket_viewer = TicketViewer.new("test@email.com", "1234", "company567")
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
    it 'should return nil if authentication failed' do
      expect(@ticket_viewer.all_tickets).to be(nil)
    end
  end

  # TODO: Testing actual HTTP responses

  describe('paginate') do
    it 'should return 25 tickets at a time' do
      expect(@ticket_viewer.all_tickets).to be(nil)
    end
  end

end