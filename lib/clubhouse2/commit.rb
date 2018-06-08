module Clubhouse
	class Commit < ClubhouseResource
		def self.properties
			[ :author_email, :author_id, :author_identity, :created_at, :entity_type, :hash, :id, :merged_branch_ids, :message, :repository_id, :timestamp, :updated_at, :url ]
		end
	end
end
