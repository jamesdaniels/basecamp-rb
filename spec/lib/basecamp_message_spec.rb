require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/basecamp.rb'

describe Basecamp::Message do
  
  before(:each) do
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')
  end

  it "should return the most recent 25 messages in the given project" do
    messages = Basecamp::Message.list(2388627)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
    messages.size.should_not > 25
  end

  it "should get a list of messages for given project and specified category" do
    messages = Basecamp::Message.list(2388627, :category_id => 23864732)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
    messages.each{ |m| m.category_id.should == 23864732 }
  end
  
  it "should return a summary of all messages in the given project" do
    messages = Basecamp::Message.archive(2388627)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
  end

  it "should return a summary of all messages in the given project and specified category " do
    messages = Basecamp::Message.archive(2388627, :category_id => 23864732)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
  end
  
  it "should return list of message comments" do
    message = Basecamp::Message.find(15797423)
    comments = message.comments
    comments.should_not be_blank
    comments.should be_kind_of(Array)
  end
end
