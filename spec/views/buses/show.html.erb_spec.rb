require 'spec_helper'

describe "buses/show.html.erb" do
  before(:each) do
    @bus = assign(:bus, stub_model(Bus,
      :nameOfBus => "Name Of Bus",
      :travel => "Travel"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Name Of Bus/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Travel/)
  end
end
