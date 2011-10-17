require 'spec_helper'

describe "buses/edit.html.erb" do
  before(:each) do
    @bus = assign(:bus, stub_model(Bus,
      :new_record? => false,
      :nameOfBus => "MyString",
      :travel => "MyString"
    ))
  end

  it "renders the edit bus form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => bus_path(@bus), :method => "post" do
      assert_select "input#bus_nameOfBus", :name => "bus[nameOfBus]"
      assert_select "input#bus_travel", :name => "bus[travel]"
    end
  end
end
