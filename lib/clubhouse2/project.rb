module Clubhouse
	class Project < ClubhouseResource
		include Queryable

		def self.properties
			[
				:abbreviation, :archived, :color, :created_at, :days_to_thermometer, :description, :entity_type, :external_id,
				:follower_ids, :id, :iteration_length, :name, :show_thermometer, :start_time, :stats, :updated_at
			]
		end

		def self.api_url
			'projects'
		end

		def stories(**args)
			@stories ||= JSON.parse(@client.api_request(:get, @client.url("#{api_url}/stories"))).collect { |story| Story.new(client: @client, object: story) }
			@stories.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def create_story(**args)
			@stories = nil
			args[:project_id] = @id
			Story.validate(**args)
			@client.create_object(:story, args)
		end

		def story(**args); stories(args).first; end
	end
end
