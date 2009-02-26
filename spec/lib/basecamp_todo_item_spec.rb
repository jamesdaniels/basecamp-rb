require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/basecamp.rb'

describe Basecamp::TodoItem do
  
  before(:each) do
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')
  end

  it "should have todo list" do
    todo  = Basecamp::TodoItem.find(32416216)
    todo.todo_list.should_not be_blank
  end
 
  it "should return list of comments" do
    todo  = Basecamp::TodoItem.find(32416216)
    todo.comments.should_not be_blank
    todo.comments.should be_kind_of(Array)
  end

  it "should complete todo item" do
    todo  = Basecamp::TodoItem.find(32416216)
    todo.complete!
   
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')

    todo  = Basecamp::TodoItem.find(32416216)
    todo.completed.should == true
  end

  it "should uncomplete todo item" do
    todo  = Basecamp::TodoItem.find(32416216)
    todo.uncomplete!
   
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')

    todo  = Basecamp::TodoItem.find(32416216)
    todo.completed.should == false
  end 
end
