require 'spec_helper'

describe "seats/edit.html.erb" do
  before(:each) do
    @seat = assign(:seat, stub_model(Seat,
      :new_record? => false,
      :name_of_seat => "MyString"
    ))
  end

  it "renders the edit seat form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => seat_path(@seat), :method => "post" do
      assert_select "input#seat_name_of_seat", :name => "seat[name_of_seat]"
    end
  end
end
