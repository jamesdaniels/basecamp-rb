require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::TimeEntry do
  before(:all) do
    establish_connection
  end
  
  it "should return all time entries" do
    entries = Basecamp::TimeEntry.report
    entries.should be_kind_of(Array)
  end
  
  it "should return all time entries for a specified project" do
    entries = Basecamp::TimeEntry.all(TEST_PROJECT_ID)
    entries.should be_kind_of(Array)
  end
  
#  it "should return parent todo item" do
#    entry = Basecamp::TimeEntry.find()
#    entry.todo_item.should_not be_blank
#    entry.todo_item.class.to_s.should == 'Basecamp::TodoItem'
#  end
end
