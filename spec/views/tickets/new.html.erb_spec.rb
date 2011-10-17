require 'spec_helper'

describe "tickets/new.html.erb" do
  before(:each) do
    assign(:ticket, stub_model(Ticket, :nameOfTrip => "MyString"
    ).as_new_record)
  end

  it "renders new ticket form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => tickets_path, :method => "post" do
      assert_select "input#ticket_nameOfTrip", :name => "ticket[nameOfTrip]"
    end
  end
end

