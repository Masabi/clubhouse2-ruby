module Clubhouse
	class State < ClubhouseResource
		def self.properties
			[
				:categories, :completed, :completed_at, :completed_at_override, :created_at, :description, :entity_type,
				:id, :name, :position, :started, :started_at, :started_at_override, :state, :updated_at
			]
		end
	end
end
