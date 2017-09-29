module Clubhouse
	class Label < ClubhouseResource
		def self.properties
			[ :archived, :color, :created_at, :entity_type, :external_id, :id, :name, :stats, :updated_at ]
		end

		def self.api_url
			'labels'
		end

		def stories
			@client.projects.collect(&:stories).reduce(:+).select { |s| s.labels.collect(&:id).include? @id }
		end
	end
end
