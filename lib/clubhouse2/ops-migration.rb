require 'clubhouse2'

source_account = Clubhouse::Client.new(api_key: 'source_account_api_key')
target_account = Clubhouse::Client.new(api_key: 'target_account_api_key')

resolve_map = {}

# Map of workflows which don't directly relate to workflows in the other account
resolve_map[:workflow] = {
	'Unscheduled' => 'Backlog',
	'Ready for Deployment' => 'Awaiting UAT Deployment',
	'Waiting for other team' => 'Blocked',
	'Completed' => 'Done',
	'Rejected' => 'Icebox'
}

# Map of members which aren't named the same in both accounts
resolve_map[:member] = {
	'James' => 'James Denness',
}

# This method looks up the corresponding ID of a resource in the other account, by matching its name.
def resolve(source_client, target_client, resolve_map, type, id)
	item = source_client.send(type, id: id)
	if resolve_map[type]
		counterpart = resolve_map[type][item.name] || item.name
	else
		counterpart = item.name
	end
	target_client.send(type, name: counterpart)&.id
end

# We need to create the empty projects before we can create epics
source_account.projects.each do |this_project|
	target_account.create_project(
		this_project.to_h.merge({
			follower_ids: this_project.follower_ids.collect { |f| resolve(source_account, target_account, resolve_map, :member, f) }
		})
	) unless resolve(source_account, target_account, resolve_map, :project, this_project.id)
end

# Create labels
source_account.labels.each do |this_label|
	target_account.create_label(this_label.to_h) unless resolve(source_account, target_account, resolve_map, :label, this_label.id)
end

# Create categories
source_account.categories.each do |this_category|
	target_account.create_category(this_category.to_h) unless resolve(source_account, target_account, resolve_map, :category, this_category.id)
end

# Create milestones
source_account.milestones.each do |this_milestone|
	new_milestone = target_account.create_milestone(
		this_milestone.to_h.merge({
			labels: this_milestone.categories.collect { |c| resolve(source_account, target_account, resolve_map, :category, c ) }
		})
	) unless target_account.milestone(name: this_milestone.name)
end

# Create epics
source_account.epics.each do |this_epic|
	new_epic = target_account.create_epic(
		this_epic.to_h.merge({
			follower_ids: this_epic.follower_ids.collect { |f| resolve(source_account, target_account, resolve_map, :member, f) },
			owner_ids: this_epic.owner_ids.collect { |o| resolve(source_account, target_account, resolve_map, :member, o) },
			labels: this_epic.labels.collect { |l| resolve(source_account, target_account, resolve_map, :label, l ) },
			started_at_override: this_epic.started_at,
			completed_at_override: this_epic.completed_at,
			milestone_id: resolve(source_account, target_account, resolve_map, :milestone, this_epic.milestone_id)
		})
	) unless target_account.epic(name: this_epic.name)
end

# Fill the projects with stories
source_account.projects.each do |this_project|
	target_account_project = target_account.project(id: resolve(source_account, target_account, resolve_map, :project, this_project.id))
	this_project.stories.each do |this_story|
		new_story = target_account.create_story(
			this_story.to_h.merge({
				project_id: target_account_project.id,
				epic_id: (resolve(source_account, target_account, resolve_map, :epic, this_story.epic_id) if this_story.epic_id),
				follower_ids: this_story.follower_ids.collect { |f| resolve(source_account, target_account, resolve_map, :member, f) },
				owner_ids: this_story.owner_ids.collect { |o| resolve(source_account, target_account, resolve_map, :member, o) },
				requested_by_id: resolve(source_account, target_account, resolve_map, :member, this_story.requested_by_id),
			})
		) unless target_account_project.story(name: this_story.name)
	end
end

# Restore story links
source_account.story_links.each do |this_link|
	begin
		target_account.create_story_link(
			this_link.to_h.merge({
				object_id: resolve(source_account, target_account, resolve_map, :story, this_link.object_id),
				subject_id: resolve(source_account, target_account, resolve_map, :story, this_link.subject_id)
			})
		) unless target_account.story_link(object_id: resolve(source_account, target_account, resolve_map, :story, this_link.object_id), subject_id: resolve(source_account, target_account, resolve_map, :story, this_link.subject_id))
	rescue Clubhouse::ClubhouseAPIError => e
		if e.message[/duplicated/]
			next
		else
			raise e
		end
	end
end



