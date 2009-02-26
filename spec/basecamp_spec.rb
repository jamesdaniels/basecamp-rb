require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/basecamp.rb'

describe Basecamp do
  
  before(:each) do
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')
    @basecamp = Basecamp::Base.new
  end

  describe "Creating a resource" do
    it "should create a comment for post" do
      comment = Basecamp::Comment.new(:post_id => 15797423)
      comment.body = "test comment"
      comment.save
      c = Basecamp::Comment.find(comment.id)
      c.body.should == "test comment"
      c.id.should == comment.id.to_i
    end 
  end
  
  describe "Finding a resource" do 
    it "should find message" do
      message = Basecamp::Message.find(15797423)
      message.body.should_not be_blank
      message.category_id.should_not be_blank
    end
  end

  describe "Updating a Resource" do 
    it "should update message" do
      m = Basecamp::Message.find(15797423)
      m.body = 'Changed'
      m.save
      message = Basecamp::Message.find(15797423)
      message.body.should == 'Changed' 
    end    
  end
  
  describe "Deleting a Resource" do
    it "should delete todo item" do
      todo = Basecamp::TodoItem.create(:todo_list_id => 4501767, :content => 'Todo for destroy')
      Basecamp::TodoItem.delete(todo.id)
    end
  end

  describe "Using the non-REST inteface" do   
    it "should return array of projects" do
      @basecamp.projects.should be_kind_of(Array)
    end

    it "should return valid project with name" do
     @basecamp.projects.first.name.should_not be_empty
    end
    
    it "should find person" do
      person = @basecamp.person(2926255)
      person.should_not be_blank
    end
  end
end