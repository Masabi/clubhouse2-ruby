module Clubhouse
	class ClubhouseResource
		include Helpers

		@@subclasses = []

		def self.inherited(other)
			@@subclasses << other
		end

		# A list of properties to exlude from any create request
		def self.property_filter_create
			[
				:archived, :days_to_thermometer, :entity_type, :id, :show_thermometer, :stats, :created_at, :updated_at,
				:started_at, :completed_at, :comments, :position, :started, :project_ids, :completed, :blocker, :moved_at,
				:task_ids, :files, :comment_ids, :workflow_state_id, :story_links, :mention_ids, :file_ids, :linked_file_ids,
				:tasks
			]
		end

		# A list of properties to exlude from any update request
		def self.property_filter_update
			self.property_filter_create
		end

		def self.all
			@@subclasses
		end

		def self.subclass(sub_class)
			@@subclasses.find { |s| s.name == 'Clubhouse::%s' % sub_class.capitalize }
		end

		def self.validate(args); end

		def initialize(object: {})
			self.class.properties.each do |this_property|
				self.class.class_eval { attr_accessor(this_property.to_sym) }
				self.class.send(:define_method, (this_property.to_s + '=').to_sym) do |value|
					update({ this_property => resolve_to_ids(value) })
					instance_variable_set('@' + this_property.to_s, resolve_to_ids(value))
				end
			end

			set_properties(object) if object
			self
		end

		def set_properties(object)
			object.each_pair do |k, v|
				instance_variable_set('@' + k.to_s, value_format(k, v))
			end
		end

		def value_format(key, value)
			DateTime.strptime(value+'+0000', '%Y-%m-%dT%H:%M:%SZ%z') rescue value
		end

		def to_h
			Hash[ (self.class.properties - self.class.property_filter_create).map { |name| [ name, instance_variable_get('@' + name.to_s) ] } ].compact
		end
	end
end
