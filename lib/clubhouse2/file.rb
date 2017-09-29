module Clubhouse
	class File < ClubhouseResource
		def self.properties
			[
				:content_type, :created_at, :description, :entity_type, :external_id, :filename, :id, :mention_ids, :name,
			  	:size, :story_ids, :thumbnail_url, :updated_at, :uploader_id, :url
			]
		end

		def self.api_url
			'files'
		end
	end
end
