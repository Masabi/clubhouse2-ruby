module Clubhouse
	class Branch < ClubhouseResource
		def self.properties
			[ :created_at, :deleted, :entity_type, :merged_branch_ids, :id, :name, :persistent, :pull_requests, :repository_id, :updated_at, :url ]
		end
	end
end
