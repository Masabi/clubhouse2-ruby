module Clubhouse
	class Category < ClubhouseResource
		include Queryable

		def self.api_url
			'categories'
		end

		def self.properties
			[ :archived, :color, :created_at, :entity_type, :external_id, :id, :name, :type, :updated_at ]
		end
	end
end
