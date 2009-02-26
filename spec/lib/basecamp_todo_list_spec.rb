require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/basecamp.rb'

describe Basecamp::TodoList do
  
  before(:each) do
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')
  end

  it "should return todo items" do
    list = Basecamp::TodoList.find(4501767)
    list.todo_items.should_not be_blank
    list.todo_items.should be_kind_of(Array)
  end  
  
  it "should return all lists for a specified project" do
    list = Basecamp::TodoList.all(2388627)
    list.should_not be_blank
  end
 
  it "should return all finished lists for a specified project" do
    list = Basecamp::TodoList.all(2388627, true)
    list.should_not be_blank
    list.each { |item| item.complete.should == "true" }
  end
 
  it "should return all pending lists for a specified project" do
    list = Basecamp::TodoList.all(2388627, false)
    list.should_not be_blank
    list.each { |item| item.complete.should == "false" }
  end
end
