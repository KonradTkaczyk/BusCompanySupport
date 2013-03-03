require 'spec_helper'

describe "buses/index.html.erb" do
  before(:each) do
    assign(:buses, [
      stub_model(Bus,
        :name_of_bus => "Name Of Bus",
        :travel => "Travel"
      ),
      stub_model(Bus,
        :name_of_bus => "Name Of Bus",
        :travel => "Travel"
      )
    ])
  end

  it "renders a list of buses" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Of Bus".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Travel".to_s, :count => 2
  end
end
