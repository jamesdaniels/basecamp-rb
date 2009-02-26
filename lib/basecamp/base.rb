module Basecamp
  class Base
    attr_accessor :use_xml

    class << self
      attr_reader :site, :user, :password, :use_ssl

      def establish_connection!(site, user, password, use_ssl = false)
        @site     = site
        @user     = user
        @password = password
        @use_ssl  = use_ssl
        Resource.user = user
        Resource.password = password
        Resource.site = (use_ssl ? "https" : "http") + "://" + site
        @connection = Connection.new(self)
      end

      def connection
        @connection || raise('No connection established')
      end

    end

    def initialize
      @use_xml = false
    end

    # ==========================================================================
    # GENERAL
    # ==========================================================================

    # Return the list of all accessible projects
    def projects
      records "project", "/project/list"
    end

    # Returns the list of message categories for the given project
    def message_categories(project_id)
      records "post-category", "/projects/#{project_id}/post_categories"
    end

    # Returns the list of file categories for the given project
    def file_categories(project_id)
      records "attachment-category", "/projects/#{project_id}/attachment_categories"
    end

    # ==========================================================================
    # CONTACT MANAGEMENT
    # ==========================================================================

    # Return information for the company with the given id
    def company(id)
      record "/contacts/company/#{id}"
    end

    # Return an array of the people in the given company. If the project-id is
    # given, only people who have access to the given project will be returned.
    def people(company_id, project_id=nil)
      url = project_id ? "/projects/#{project_id}" : ""
      url << "/contacts/people/#{company_id}"
      records "person", url
    end

    # Return information about the person with the given id
    def person(id)
      record "/contacts/person/#{id}"
    end

    # ==========================================================================
    # MILESTONES
    # ==========================================================================

    # Complete the milestone with the given id
    def complete_milestone(id)
      record "/milestones/complete/#{id}"
    end

    # Create a new milestone for the given project. +data+ must be hash of the
    # values to set, including +title+, +deadline+, +responsible_party+, and
    # +notify+.
    def create_milestone(project_id, data)
      create_milestones(project_id, [data]).first
    end

    # As #create_milestone, but can create multiple milestones in a single
    # request. The +milestones+ parameter must be an array of milestone values as
    # descrbed in #create_milestone.
    def create_milestones(project_id, milestones)
      records "milestone", "/projects/#{project_id}/milestones/create", :milestone => milestones
    end

    # Destroys the milestone with the given id.
    def delete_milestone(id)
      record "/milestones/delete/#{id}"
    end

    # Returns a list of all milestones for the given project, optionally filtered
    # by whether they are completed, late, or upcoming.
    def milestones(project_id, find="all")
      records "milestone", "/projects/#{project_id}/milestones/list", :find => find
    end

    # Uncomplete the milestone with the given id
    def uncomplete_milestone(id)
      record "/milestones/uncomplete/#{id}"
    end

    # Updates an existing milestone.
    def update_milestone(id, data, move=false, move_off_weekends=false)
      record "/milestones/update/#{id}", :milestone => data,
      :move_upcoming_milestones => move,
        :move_upcoming_milestones_off_weekends => move_off_weekends
    end

    private

    # Make a raw web-service request to Basecamp. This will return a Hash of
    # Arrays of the response, and may seem a little odd to the uninitiated.
    def request(path, parameters = {})
      response = Base.connection.post(path, convert_body(parameters), "Content-Type" => content_type)

      if response.code.to_i / 100 == 2
        result = XmlSimple.xml_in(response.body, 'keeproot' => true, 'contentkey' => '__content__', 'forcecontent' => true)
        typecast_value(result)
      else
        raise "#{response.message} (#{response.code})"
      end
    end

    # A convenience method for wrapping the result of a query in a Record
    # object. This assumes that the result is a singleton, not a collection.
    def record(path, parameters={})
      result = request(path, parameters)
      (result && !result.empty?) ? Record.new(result.keys.first, result.values.first) : nil
    end

    # A convenience method for wrapping the result of a query in Record
    # objects. This assumes that the result is a collection--any singleton
    # result will be wrapped in an array.
    def records(node, path, parameters={})
      result = request(path, parameters).values.first or return []
      result = result[node] or return []
      result = [result] unless Array === result
      result.map { |row| Record.new(node, row) }
    end

    def convert_body(body)
      body = use_xml ? body.to_legacy_xml : body.to_yaml
    end

    def content_type
      use_xml ? "application/xml" : "application/x-yaml"
    end

    def typecast_value(value)
      case value
      when Hash
        if value.has_key?("__content__")
          content = translate_entities(value["__content__"]).strip
          case value["type"]
          when "integer"  then content.to_i
          when "boolean"  then content == "true"
          when "datetime" then Time.parse(content)
          when "date"     then Date.parse(content)
          else                 content
          end
          # a special case to work-around a bug in XmlSimple. When you have an empty
          # tag that has an attribute, XmlSimple will not add the __content__ key
          # to the returned hash. Thus, we check for the presense of the 'type'
          # attribute to look for empty, typed tags, and simply return nil for
          # their value.
        elsif value.keys == %w(type)
          nil
        elsif value["nil"] == "true"
          nil
          # another special case, introduced by the latest rails, where an array
          # type now exists. This is parsed by XmlSimple as a two-key hash, where
          # one key is 'type' and the other is the actual array value.
        elsif value.keys.length == 2 && value["type"] == "array"
          value.delete("type")
          typecast_value(value)
        else
          value.empty? ? nil : value.inject({}) do |h,(k,v)|
            h[k] = typecast_value(v)
            h
          end
        end
      when Array
        value.map! { |i| typecast_value(i) }
        case value.length
        when 0 then nil
        when 1 then value.first
        else value
        end
      else
        raise "can't typecast #{value.inspect}"
      end
    end

    def translate_entities(value)
      value.gsub(/&lt;/, "<").
        gsub(/&gt;/, ">").
        gsub(/&quot;/, '"').
        gsub(/&apos;/, "'").
        gsub(/&amp;/, "&")
    end 
  end
end

