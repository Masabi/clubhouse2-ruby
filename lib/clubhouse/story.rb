module Clubhouse
	class Story
		@@stories = []
		attr_reader :archived, :blocker, :blocker, :comment_ids, :completed, :completed_at, :completed_at_override, :created_at
		attr_reader :deadline, :entity_type, :epic_id, :estimate, :external_id, :file_ids, :follower_ids, :id, :labels,
		attr_reader :linked_file_ids, :moved_at, :name, :owner_ids, :position, :project_id, :requested_by_id, :started,
		attr_reader :started_at, :started_at_override, :story_links, :story_type, :task_ids, :updated_at, :workflow_state_id

		def initialize(**args)
			args.each_pair { |k, v| instance_variable_set('@' + k, v) }
			@@stories << self
		end
	end
end
