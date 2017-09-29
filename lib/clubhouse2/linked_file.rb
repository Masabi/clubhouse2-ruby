module Clubhouse
	class Linkedfile < ClubhouseResource
		def self.properties
			[
				:content_type, :created_at, :description, :entity_type, :id, :mention_ids, :name,
				:size, :story_ids, :thumbnail_url, :type, :updated_at, :uploader_id
			]
		end

		def self.api_url
			'linkedfiles'
		end
	end
end
