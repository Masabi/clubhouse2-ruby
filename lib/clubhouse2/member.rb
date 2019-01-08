module Clubhouse
	class Member < ClubhouseResource
		include Queryable

		def self.properties
			[ :created_at, :disabled, :id, :profile, :role, :updated_at ]
		end

		def initialize(client: nil, object: {})
			super
			@profile = Profile.new(object: @profile)

			# Create accessors for profile properties
			Profile.properties.each do |property|
				self.class.send(:define_method, (property.to_sym)) { @profile.send(property) }
			end
		end

		def self.api_url
			'members'
		end

		def stories_requested
			@client.projects.collect(&:stories).reduce(:+).select { |s| s.requested_by_id == @id }
		end

		def stories_following
			@client.projects.collect(&:stories).reduce(:+).select { |s| s.follower_ids.include? @id }
		end
	end
end
