require 'spec_helper'

describe "tickets/index.html.erb" do
  before(:each) do
    assign(:tickets, [
      stub_model(Ticket,
        :nameOfTrip => "Name Of Trip"
      ),
      stub_model(Ticket,
        :nameOfTrip => "Name Of Trip"
      )
    ])
  end

  it "renders a list of tickets" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Of Trip".to_s, :count => 2
  end
end

