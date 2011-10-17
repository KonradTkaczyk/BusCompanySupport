require 'spec_helper'

describe "seats/show.html.erb" do
  before(:each) do
    @seat = assign(:seat, stub_model(Seat,
      :nameOfSeat => "Name Of Seat"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Name Of Seat/)
  end
end
