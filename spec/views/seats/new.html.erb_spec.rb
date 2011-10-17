require 'spec_helper'

describe "seats/new.html.erb" do
  before(:each) do
    assign(:seat, stub_model(Seat,
      :nameOfSeat => "MyString"
    ).as_new_record)
  end

  it "renders new seat form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => seats_path, :method => "post" do
      assert_select "input#seat_nameOfSeat", :name => "seat[nameOfSeat]"
    end
  end
end
