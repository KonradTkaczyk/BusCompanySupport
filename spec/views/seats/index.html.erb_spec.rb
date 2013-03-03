require 'spec_helper'

describe "seats/index.html.erb" do
  before(:each) do
    assign(:seats, [
      stub_model(Seat,
        :name_of_seat => "Name Of Seat"
      ),
      stub_model(Seat,
        :name_of_seat => "Name Of Seat"
      )
    ])
  end

  it "renders a list of seats" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Of Seat".to_s, :count => 2
  end
end
