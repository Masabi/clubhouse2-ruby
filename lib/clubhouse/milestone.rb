module Clubhouse
	class Milestone
		@@milestones = []

		def self.[](name)
			@@milestones.find { |milestone| milestone.name == name.to_s or milestone.id == id }
		end

		def inititalize(client:, **args)
			@client = client
			args.each_pair { |k, v| instance_variable_set('@' + k, v) }
			@@milestones << self
		end

		def [](epic_id)
			epics.find { |story| story.id == id.to_i }
		end

		def epics
			@epics ||= JSON.parse(HTTP.get(@client.url('epics'))).collect { |epic| Epic.new(epic) }
		end
	end
end
