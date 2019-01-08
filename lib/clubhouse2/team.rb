module Clubhouse
	class Team < ClubhouseResource
		include Queryable

		def self.properties
			[
				:created_at, :description, :entity_type, :id, :name, :position, :project_ids, :updated_at, :workflow,
				:team_id, :updated_at
			]
		end

		def self.api_url
			'teams'
		end
	end
end
