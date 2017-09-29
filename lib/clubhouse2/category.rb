module Clubhouse
	class Category < ClubhouseResource
		attr_reader :archived, :color, :created_at, :entity_type, :external_id, :id, :name, :type, :updated_at

		def self.api_url
			'categories'
		end
	end
end
