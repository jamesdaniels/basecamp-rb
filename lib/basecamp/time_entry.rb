module Basecamp
  class TimeEntry < Resource
    parent_resources :project, :todo_item

    def self.all(project_id, page=0)
      find(:all, :params => { :project_id => project_id, :page => page })
    end

    def self.report(options={})
      find(:all, :from => :report, :params => options)
    end

    def todo_item(options={})
      @todo_item ||= todo_item_id && TodoItem.find(todo_item_id, options)
    end    
  end
end
