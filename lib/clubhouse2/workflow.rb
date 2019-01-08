module Clubhouse
	class Workflow < ClubhouseResource		
		include Queryable

		def self.properties
			[ :created_at, :default_state_id, :description, :entity_type, :id, :name, :team_id, :updated_at ]
		end

		def initialize(client: nil, object: {})
			super
			@states = []
			object['states']&.each do |this_state|
				this_state[:workflow_id] = @id
				@states << State.new(object: this_state)
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
