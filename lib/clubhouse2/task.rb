module Clubhouse
	class Task < ClubhouseResource
		include Queryable

		def self.properties
			[
				:complete, :completed_at, :created_at, :description, :entity_type, :external_id, :id, :mention_ids, :owner_ids,
				:position, :story_id, :updated_at
			]
		end

		def self.api_url
			'tasks'
		end

		def to_h
			super.reject { |k, v| [ :story_id ].include? k }
		end
	end
end
