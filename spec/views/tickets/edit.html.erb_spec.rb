require 'spec_helper'

describe "tickets/edit.html.erb" do
  before(:each) do
    @ticket = assign(:ticket, stub_model(Ticket,
      :new_record? => false,
      :nameOfTrip => "MyString"
    ))
  end

  it "renders the edit ticket form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => ticket_path(@ticket), :method => "post" do
      assert_select "input#ticket_nameOfTrip", :name => "ticket[nameOfTrip]"
    end
  end
end

