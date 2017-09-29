module Clubhouse
	class Repository < ClubhouseResource
		def self.properties
			[ :created_at, :entity_type, :external_id, :full_name, :id, :name, :type, :updated_at, :url ]
		end

		def self.api_url
			'repositories'
		end
	end
end
