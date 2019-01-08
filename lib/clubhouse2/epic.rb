module Clubhouse
	class Epic < ClubhouseResource
		include Queryable

		def self.properties
			[
				:archived, :comments, :completed, :completed_at, :completed_at_override, :created_at, :deadline, :description,
				:entity_type, :external_id, :follower_ids, :id, :labels, :milestone_id, :name, :owner_ids, :position, :project_ids,
				:started, :started_at, :started_at_override, :state, :stats, :updated_at
			]
		end

		def self.api_url
			'epics'
		end

		def stories
			@client.projects.collect(&:stories).reduce(:+).select { |s| s.epic_id == @id }
		end

		def validate(args)
			raise NoSuchTeam.NoSuchTeam(args[:team_id]) unless @client.get_team(id: args[:team_id])

			(args[:follower_ids] || []).each do |this_member|
				raise NoSuchMember.NoSuchMember(this_member) unless @client.get_member(id: this_member)
			end

			(args[:owner_ids] || []).each do |this_member|
				raise NoSuchMember.NoSuchMember(this_member) unless @client.get_member(id: this_member)
			end
		end

		def comments(**args)
			# The API is missing a parent epic ID property, so we need to fake it here
			args[:epic_id] = @id
			@comments ||= JSON.parse(@client.api_request(:get, @client.url("#{api_url}/#{Epiccomment.api_url}"))).collect { |task| Epiccomment.new(client: @client, object: comment) }
			@comments.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def to_h
			super.merge({
				comments: @comments.collect(&:to_h)
			})
		end

		def create_comment(**args)
			Task.validate(args)
			response = JSON.parse(@client.api_request(:post, @client.url("#{api_url}/#{Epiccomment.api_url}"), :json => args))
			raise ClubhouseAPIError.new(response) unless response.code == 201
			@comments = nil
			response
		end

		def comment(**args); comments(args).first; end
	end
end
