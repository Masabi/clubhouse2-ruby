module Clubhouse
	class Milestone < ClubhouseResource
		def self.properties
			[
				:categories, :completed, :completed_at, :completed_at_override, :created_at, :description, :entity_type,
				:id, :name, :position, :started, :started_at, :started_at_override, :state, :updated_at
			]
		end

		def self.api_url
			'milestones'
		end

		def epics
			@client.epics.select { |e| e.milestone_id == @id }			
		end

		def stories
			epics.collect(&:stories).reduce(:+)
		end
	end
end
