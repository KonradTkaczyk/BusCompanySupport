require 'spec_helper'

describe "buses/new.html.erb" do
  before(:each) do
    assign(:bus, stub_model(Bus,
      :nameOfBus => "MyString",
      :travel => "MyString"
    ).as_new_record)
  end

  it "renders new bus form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => buses_path, :method => "post" do
      assert_select "input#bus_nameOfBus", :name => "bus[nameOfBus]"
      assert_select "input#bus_travel", :name => "bus[travel]"
    end
  end
end
