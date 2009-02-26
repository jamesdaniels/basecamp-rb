require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../lib/basecamp.rb'

describe Basecamp::Base do
  
  before(:each) do
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')
    @basecamp = Basecamp::Base.new
  end

  it "should return the list of all accessible projects" do
    @basecamp.projects.should_not be_blank
    @basecamp.projects.should be_kind_of(Array)
  end

  it "should return valid project with name" do
    @basecamp.projects.first.name.should_not be_empty
  end
    
  it "should find person" do
    person = @basecamp.person(2926255)
    person.should_not be_blank
  end
  
  it "should return the list of message categories for the given project" do
    categories = @basecamp.message_categories(2388627)
    categories.should_not be_blank
    categories.should be_kind_of(Array)
  end
  
  # CONTACT MANAGEMENT
  
  it "should return information for the company with the given id" do
    company = @basecamp.company(1098114)
    company.should_not be_blank
  end
  
  it "should return an array of the people in the given company" do
    people = @basecamp.people(1098114)
    people.should_not be_blank
    people.should be_kind_of(Array)
  end
  
  it "should return information about the person with the given id" do
    @basecamp.person(2926255).should_not be_nil
  end
  
  # MILESTONES
 
  it "should return a list of all milestones for the given project" do
    milestones = @basecamp.milestones(2388627)
    milestones.should be_kind_of(Array)
    milestones.should_not be_blank
  end

  it "should complete milestone with the given id" do
    milestone = @basecamp.milestones(2388627).first
    @basecamp.complete_milestone(milestone.id)
   
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')

    milestone = @basecamp.milestones(2388627).first
    milestone.completed.should == true
  end

  it "should uncomplete milestone with the given id" do
    milestone = @basecamp.milestones(2388627).first
    @basecamp.uncomplete_milestone(milestone.id)
   
    Basecamp::Base.establish_connection!('flatsoft-test.grouphub.com', 'flatsoft', '123456')

    milestone = @basecamp.milestones(2388627).first
    milestone.completed.should == false
  end
end
