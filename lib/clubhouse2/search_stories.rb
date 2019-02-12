module Clubhouse
	class SearchStories < ClubhouseResource

		def self.properties
			[ :data, :next, :total ]
		end

		def self.api_url
			'search/stories'
		end

		def api_url
			"#{self.api_url}/#{@story_id}/#{id}"
		end
	end
end
