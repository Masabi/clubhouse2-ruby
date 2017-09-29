module Clubhouse
	class Workflow < ClubhouseResource		
		def self.properties
			[ :created_at, :default_state_id, :description, :entity_type, :id, :name, :states, :team_id, :updated_at ]
		end

		def initialize(client:, object:)
			super
			@states = []
			object['states'].each do |this_state|
				this_state[:workflow_id] = @id
				@states << State.new(client: client, object: this_state)
			end
		end

		def self.api_url
			'workflows'
		end

		def states(**args)
			@states.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def state(**args); states(args).first; end
	end
end
