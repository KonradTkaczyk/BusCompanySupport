require 'spec_helper'

describe "tickets/show.html.erb" do
  before(:each) do
    @ticket = assign(:ticket, stub_model(Ticket,
      :nameOfTrip => "Name Of Trip"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Name Of Trip/)
  end
end

