require 'http'
require 'uri'
require 'json'

module Clubhouse
	class Client
		def initialize(api_key:, base_url: 'https://api.clubhouse.io/api/v2/')
			@api_key = api_key
			@base_url = base_url
		end

		def url(endpoint)
			URI.join(@base_url, endpoint)
		end

		# ---

		def projects
			JSON.parse(HTTP.get(@client.url("projects"))).collect { |project| Project.new(project) }
			@@projects
		end
	end
end
