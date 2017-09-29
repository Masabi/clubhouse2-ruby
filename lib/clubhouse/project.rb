module Clubhouse
	class Project
		@@projects = []
		@@client = nil

		attr_reader :abbreviation, :archived, :color, :created_at, :days_to_thermometer, :description, :entity_type, :external_id
		attr_reader :follower_ids, :id, :iteration_length, :name, :show_thermometer, :start_time, :stats, :team_id, :updated_at

		def self.[](name)
			@@projects.find { |project| project.name == name.to_s } || Project.get(name: name)
		end

		def self.all
			@@projects
		end

		def self.get(name)
			JSON.parse(HTTP.get(@@client.url("projects/#{@name}"))).collect { |project| Project.new(project) }
		end

		def inititalize(**args)
			args.each_pair { |k, v| instance_variable_set('@' + k, v) }
			@@projects << self
		end

		def [](story_id)
			stories.find { |story| story.id == id.to_i }
		end

		def stories
			@stories ||= JSON.parse(HTTP.get(@@client.url("projects/#{@name}/stories"))).collect { |story| Story.new(story) }
		end
	end
end
