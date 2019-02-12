require 'json'

module Clubhouse
  class SearchStoriesPage

    attr_reader :next, :total, :stories

    def initialize(client:, json_object:)
      @client = client

      @data = json_object['data']
      @next = json_object['next']
      @total = json_object['total']

      @stories = @data.map{|item| Story.new(client: @client, object: item)}

    end

    def self.properties
      [ :data, :next, :total ]
    end

    def self.api_url
      'search/stories'
    end

    def next_page_id
      return nil if @next.blank?

      CGI.parse(URI::parse(@next).query)['next'].first
    end

  end
end
