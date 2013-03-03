require 'spec_helper'

describe "buses/new.html.erb" do
  before(:each) do
    assign(:bus, stub_model(Bus,
      :name_of_bus => "MyString",
      :travel => "MyString"
    ).as_new_record)
  end

  it "renders new bus form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => buses_path, :method => "post" do
      assert_select "input#bus_name_of_bus", :name => "bus[name_of_bus]"
      assert_select "input#bus_travel", :name => "bus[travel]"
    end
  end
end
