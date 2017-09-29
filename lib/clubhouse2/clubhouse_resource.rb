module Clubhouse
	class ClubhouseResource
		@@subclasses = []

		def self.inherited(other)
			@@subclasses << other
		end

		# A list of properties to exlude from any create request
		def self.property_filter_create
			[
				:archived, :days_to_thermometer, :entity_type, :id, :show_thermometer, :stats, :created_at, :updated_at,
				:started_at, :completed_at, :comments, :position, :started, :project_ids, :completed, :blocker, :moved_at,
				:task_ids, :files, :comment_ids, :workflow_state_id, :story_links, :mention_ids, :file_ids, :linked_file_ids
			]
		end

		# A list of properties to exlude from any update request
		def self.property_filter_update
			self.property_filter_create
		end

		def self.subclass(sub_class)
			@@subclasses.find { |s| s.name == 'Clubhouse::%s' % sub_class.capitalize }
		end

		def api_url
			self.class.api_url + "/#{@id}"
		end

		def self.validate(args); end

		def initialize(client:, object:)
			@client = client

			self.class.properties.each do |this_property|
				self.class.class_eval { attr_accessor(this_property.to_sym) }
				self.class.send(:define_method, (this_property.to_s + '=').to_sym) do |value|
					update({ this_property => value })
				end
			end

			set_properties(object)
			self
		end

		def set_properties(object)
			object.each_pair do |k, v|
				instance_variable_set('@' + k.to_s, v)
			end
		end

		# Empties resource cache
		def flush
			@client.flush(self.class)
		end

		def update(args = {})
			new_params = to_h.merge(args).reject { |k, v| self.class.property_filter_update.include? k.to_sym }
			validate(new_params)
			flush
			@client.api_request(:put, @client.url(api_url), :json => new_params)
		end

		def delete!
			flush
			@client.api_request(:delete, @client.url(api_url))
		end

		def to_h
			Hash[ (self.class.properties - self.class.property_filter_create).map { |name| [ name, instance_variable_get('@' + name.to_s) ] } ].compact
		end
	end
end