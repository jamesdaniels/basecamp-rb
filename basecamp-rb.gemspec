# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{basecamp-rb}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Turing Studio, Inc."]
  s.date = %q{2009-02-25}
  
  s.email = ["operations@turingstudio.com"]
  s.description = %q{FIX (describe your package)}
  s.summary = %q{FIX (describe your package)}
  s.files = [
    "History.txt",
    "README.rdoc",
    "lib/basecamp.rb",
    "lib/basecamp/base.rb",    
    "lib/basecamp/version.rb",
    "lib/basecamp/resource.rb",
    "lib/basecamp/attachment.rb",
    "lib/basecamp/comment.rb",
    "lib/basecamp/connection.rb",
    "lib/basecamp/message.rb",
    "lib/basecamp/record.rb",
    "lib/basecamp/time_entry.rb",
    "lib/basecamp/todoitem.rb",
    "lib/basecamp/todolist.rb",
    "lib/basecamp/company.rb",
    "lib/basecamp/file_category.rb",
    "lib/basecamp/milestone.rb",
    "lib/basecamp/project.rb",
    "lib/basecamp/person.rb",
    "lib/basecamp/post_category.rb",
    "spec/basecamp_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/lib/basecamp_base.rb",
    "spec/lib/basecamp_message_spec.rb",
    "spec/lib/basecamp_todo_item_spec.rb",
    "spec/lib/basecamp_todo_list_spec.rb",
    "tasks/rspec.rake"
  ]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.homepage = %q{http://github.com/turingstudio/basecamp-rb/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 1.0.11"])
      s.add_runtime_dependency(%q<activeresource>, [">= 2.2.2"])
    else
      s.add_dependency(%q<xml-simple>, [">= 1.0.11"])
      s.add_dependency(%q<activeresource>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 1.0.11"])
    s.add_dependency(%q<activeresource>, [">= 2.2.2"])
  end
end
