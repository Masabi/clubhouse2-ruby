module Clubhouse
	class Storycomment < ClubhouseResource
		include Queryable

		def self.properties
			[ :author_id, :comments, :created_at, :entity_type, :external_id, :id, :mention_ids, :position, :story_id, :text, :updated_at ]
		end

		def self.api_url
			'comments'
		end

		def api_url
			"#{self.api_url}/#{@story_id}/#{id}"
		end
	end
end
