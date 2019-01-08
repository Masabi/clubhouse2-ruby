require 'http'
require 'uri'
require 'json'

module Clubhouse
	class Client
		def initialize(api_key:, base_url: 'https://api.clubhouse.io/api/v2/')
			@api_key = api_key
			@base_url = base_url
			@resources = {}
		end

		def url(endpoint)
			URI.join(@base_url, endpoint,'?token=%s' % @api_key)
		end

		def api_request(method, *params)
			retries = 3
			while true
				response = HTTP.headers(content_type: 'application/json').send(method, *params)
				case response.code
				when 429
					sleep 30
					retries = retries - 1
					break if retries == 0
				when 200
					break
				when 201
					break
				else
					raise ClubhouseAPIError.new(response)
				end
			end

			response
		end

		def flush(resource_class)
			@resources[resource_class] = nil
		end

		# Take all the provided properties, and filter out any resources that don't match.
		# If the value of a property is an object with an ID, match on that ID instead (makes for tidier queries)
		def filter(object_array, args)
			object_array.reject { |s| args.collect { |k, v| not resolve_to_ids([ *s.send(k) ]).include? resolve_to_ids(v) }.reduce(:|) }
		end

		def resolve_to_ids(object)
			return object.collect { |o| resolve_to_ids(o) } if object.is_a? Array
			(object.respond_to?(:id) ? object.id : object)
		end

		# or v.empty? if v.respond_to?(:empty?)
		def create_object(resource_class, args)
			this_class = Clubhouse::ClubhouseResource.subclass(resource_class)
			this_class.validate(args)
			flush(this_class)
			new_params = args.compact.reject { |k, v| this_class.property_filter_create.include? k.to_sym }
			response = api_request(:post, url(this_class.api_url), :json => new_params)
			JSON.parse(response.to_s)
		end

		def get_objects(resource_class, args = {})
			this_class = Clubhouse::ClubhouseResource.subclass(resource_class)
			unless @resources[this_class]
				response = api_request(:get, url(this_class.api_url))
				@resources[this_class] = JSON.parse(response.to_s).collect do |resource|
					this_class.new(client: self, object: resource)
				end
			end

			filter(@resources[this_class], args)
		end

		def get_object(resource_class, args = {})
			get_objects(resource_class, args).first
		end

		# ---

		def create_milestone(**args); create_object(:milestone, args); end
		def milestones(**args); get_objects(:milestone, args); end
		def milestone(**args); get_object(:milestone, args); end

		def create_project(**args); create_object(:project, args); end
		def projects(**args); get_objects(:project, args); end
		def project(**args); get_object(:project, args); end

		def create_story(**args); create_object(:story, args); end
		def stories(**args)
			filter(get_objects(:project).collect(&:stories).flatten, args)
		end

		def story(**args); stories(**args).first; end

		def create_story_link(**args); create_object(:storylink, args); end
		def story_links(**args)
			filter(stories.collect(&:story_links).flatten, args)
		end

		def story_link(**args); story_links(**args).first; end

		def create_member(**args); create_object(:member, args); end
		def members(**args); get_objects(:member, args); end
		def member(**args); get_object(:member, args); end

		def create_team(**args); create_object(:team, args); end
		def teams(**args); get_objects(:team, args); end
		def team(**args); get_object(:team, args); end

		def create_epic(**args); create_object(:epic, args); end
		def epics(**args); get_objects(:epic, args); end
		def epic(**args); get_object(:epic, args); end

		def create_category(**args); create_object(:category, args); end
		def categories(**args); get_objects(:category, args); end
		def category(**args); get_object(:category, args); end

		def create_label(**args); create_object(:label, args); end
		def update_label(**args); update_object(:label, args); end
		def labels(**args); get_objects(:label, args); end
		def label(**args); get_object(:label, args); end

		def create_file(**args); create_object(:file, args); end
		def files(**args); get_objects(:file, args); end
		def file(**args); get_object(:file, args); end

		def create_linked_file(**args); create_object(:linkedfile, args); end
		def linked_files(**args); get_objects(:linkedfile, args); end
		def linked_file(**args); get_object(:linkedfile, args); end

		def create_workflow(**args); create_object(:workflow, args); end
		def workflows(**args); get_objects(:workflow, args); end
		def workflow(**args); get_object(:workflow, args); end
	end
end
