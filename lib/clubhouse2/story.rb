module Clubhouse
	class Story < ClubhouseResource
		def self.properties
			[
				:archived, :blocker, :blocker, :comment_ids, :completed, :completed_at, :completed_at_override, :created_at,
				:deadline, :entity_type, :epic_id, :estimate, :external_id, :file_ids, :follower_ids, :id,
				:linked_file_ids, :moved_at, :name, :owner_ids, :position, :project_id, :requested_by_id, :started,
				:started_at, :started_at_override, :story_type, :task_ids, :updated_at, :workflow_state_id,
			]
		end

		def self.api_url
			'stories'
		end

		def validate(**args)
			raise NoSuchEpic.new(args[:epic_id]) unless @client.epic(id: args[:epic_id]) if args[:epic_id] 
			raise NoSuchProject.new(args[:project_id]) unless @client.project(id: args[:project_id]) if args[:project_id] 
			raise NoSuchMember.new(args[:requested_by_id]) unless @client.member(id: args[:requested_by_id]) if args[:requested_by_id] 
		
			(args[:follower_ids] || []).each do |this_member|
				raise NoSuchMember.new(this_member) unless @client.member(id: this_member)
			end

			(args[:owner_ids] || []).each do |this_member|
				raise NoSuchMember.new(this_member) unless @client.member(id: this_member)
			end

			(args[:file_ids] || []).each do |this_file|
				raise NoSuchFile.new(this_file) unless @client.file(id: this_file)
			end

			(args[:linked_file_ids] || []).each do |this_linked_file|
				raise NoSuchLinkedFile.new(this_linked_file) unless @client.linked_file(id: this_linked_file)
			end

			(args[:story_links] || []).each do |this_linked_story|
				raise NoSuchLinkedStory.new(this_linked_story) unless @client.story(id: this_linked_story['subject_id'])
			end

			(args[:labels] || []).collect! do |this_label|
				this_label.is_a? Label ? this_label : @client.label(id: this_label['name'])
			end
		end

		def create_task(**args)
			Task.validate(**args)
			@tasks = nil
			JSON.parse(@client.api_request(:post, @client.url("#{api_url}/#{Task.api_url}"), :json => args))
		end

		def comments(**args)
			@comments ||= @comment_ids.collect do |this_comment_id|
				comment_data = JSON.parse(@client.api_request(:get, @client.url("#{api_url}/comments/#{this_comment_id}")))
				Storycomment.new(client: @client, object: comment_data)
			end

			@comments.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def story_links(**args)
			@story_link_objects ||= @story_links.collect do |this_story_link|
				link_data = JSON.parse(@client.api_request(:get, @client.url("#{Storylink.api_url}/#{this_story_link['id']}")))
				link_data.reject { |k, v| v == @id}
				Storylink.new(client: @client, object: link_data)
			end

			@story_link_objects.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def tasks(**args)
			@tasks ||= @task_ids.collect do |this_task_id|
				task_data = JSON.parse(@client.api_request(:get, @client.url("#{api_url}/tasks/#{this_task_id}")))
				Task.new(client: @client, object: task_data)
			end

			@tasks.reject { |s| args.collect { |k,v| s.send(k) != v }.reduce(:|) }
		end

		def linked_files(**args)
			@client.linked_files(story_ids: @id, **args)
		end

		def files(**args)
			@client.files(story_ids: @id, **args)
		end

		def labels(**args)
			@labels.collect { |l| @client.label(id: l['id'], **args) }
		end

		def to_h
			super.merge({
				comments: [ *comments ].collect(&:to_h),
				tasks: [ *tasks ].collect(&:to_h),
				files: [ *files ].collect(&:to_h),
				story_links: [ *story_links ].collect(&:to_h),
				labels: [ *labels ].collect(&:to_h),
			})
		end

		def create_comment(**args)
			Task.validate(**args)
			@comments = nil
			JSON.parse(@client.api_request(:post, @client.url("#{api_url}/#{Storycomment.api_url}"), :json => args))
		end

		def comment(**args); comments(args).first; end
		def story_link(**args); story_links(args).first; end
		def task(**args); tasks(args).first; end
	end
end
