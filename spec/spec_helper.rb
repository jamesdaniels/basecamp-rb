begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.dirname(__FILE__) + '/../lib/basecamp'

SITE_URL = 'flatsoft.grouphub.com'
LOGIN = 'alexey.panin'
PASSWORD = '5721955'
USE_SSL = true  

TEST_PROJECT_ID = 2971868
TEST_MESSAGE_ID = 20216236   # TEST_MESSAGE SHOULD BELONG TO TEST PROJECT!!!
TEST_COMPANY_ID = 1040098
TEST_PERSON_ID = 2766635
TEST_TODO_LIST_ID = 5576947

def establish_connection
  Basecamp::Base.establish_connection!(SITE_URL, LOGIN, PASSWORD, USE_SSL)
end

def create_comments_for_message(id)
  comment = Basecamp::Comment.new(:post_id => id)
  comment.body = "test comment"
  comment.save
end

def delete_comments_for_message(id)
  message = Basecamp::Message.find(id)
  message.comments.each {|c| Basecamp::Comment.delete(c.id)}
end

def delete_time_entries_for_project(id)
  entry = Basecamp::Project.find(id)
  message.comments.each {|c| Basecamp::Comment.delete(c.id)}
end 

def create_todo_list_for_project_with_todo(id)
  todo_list = Basecamp::TodoList.create(
    :project_id   => id,
    :tracked      => true,
    :description  => 'private',
    :private      => false
  )
  todo = Basecamp::TodoItem.create(
    :todo_list_id => todo_list.id,
    :content      => 'Do it'
  )
  comment = Basecamp::Comment.new(:todo_item_id => todo.id)
  comment.body = "test comment"
  comment.save
  
  todo.todo_list_id = todo_list.id
  todo
end

def create_pending_and_finished_lists(id)
  list1 = Basecamp::TodoList.create(:project_id => id, :tracked => true, :description => 'private1', :private => false)
  list2 = Basecamp::TodoList.create(:project_id => id, :tracked => true, :description => 'private2', :private => false)
  [ list1.id, list2.id ]
end

def create_milestone_for_project(id)
  Basecamp::Milestone.create(TEST_PROJECT_ID,
    :title             => 'new',
    :responsible_party => TEST_PERSON_ID, 
    :deadline          => Time.now,
    :notify            => false
  )
end
