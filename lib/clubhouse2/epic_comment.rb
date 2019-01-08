module Clubhouse
	class Epiccomment < ClubhouseResource
		include Queryable

		def self.properties
			[ :author_id, :comments, :created_at, :entity_type, :external_id, :id, :mention_ids, :position, :text, :updated_at, :epic_id ]
		end

		def self.api_url
			'comments'
		end

		def api_url
			"#{self.api_url}/#{@epic_id}/#{id}"
		end
	end
end
