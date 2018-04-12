module Clubhouse
	class PullRequest < ClubhouseResource
		def self.properties
			[ :branch_id, :closed, :entity_type, :created_at, :id, :num_added, :num_commits, :num_modified, :num_removed, :number, :target_branch_id, :title, :updated_at, :url ]
		end
	end
end
