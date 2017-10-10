# Clubhouse API v2 Ruby Gem

This is a resource-oriented ruby library for interacting with the Clubhouse v2 API. 

## How to use

### Initializing the client
```ruby
require 'clubhouse2'
client = Clubhouse::Client.new(api_key: 'your_api_key')
```

### Quick-start
#### Queries
Get all stories being followed by a user called 'James'.
```ruby
client.stories(follower_ids: client.member(name: 'James'))
```

Get all stories in the 'Testing' project in the 'Completed' state.
```ruby
client.project(name: 'Testing').stories(workflow_state_id: client.workflow.state(name: 'Completed'))
```

Get the names of all stories in the 'Testing' project
```ruby
client.project(name: 'Testing').stories.collect(&:name)
```

Get all non-archived stories with the label 'Out Of Hours'
```ruby
client.stories(archived: false, labels: client.label(name: 'Out Of Hours'))
```

Get all stories last updated more than 30 days ago
```ruby
client.stories.select { |story| story.updated_at < Date.today - 30 }
```

Get a list of all story states in the default workflow
```ruby
client.workflow.states
```

#### Creating resources
See the official Clubhouse API documentation for valid properties to use here:
https://clubhouse.io/api/rest/v2/

Create a new story in the 'Testing' project
```ruby
client.project(name: 'Testing').create_story( **...** )
client.create_story(project_id: client.project(name: 'Testing'), **...** )
```

#### Updating resources
Updating a property of a resource can be achieved simply by using assignment operators, as shown in the examples below.

See the official Clubhouse API documentation for valid properties to use here:
https://clubhouse.io/api/rest/v2/

Change the name of a story
```ruby
client.story(name: 'Old name').name = 'New name'
client.story(id: 123).name = 'New name'
```

Add a new follower to a story
```ruby
client.story(id: 123).follower_ids += [ client.member(name: 'Jeff') ]
```

Assign a story to an epic
```ruby
client.story(id: 123).epic_id = client.epic(name: 'Awesome')
```

#### Deleting resources
Deletion is possible by using the `delete!` method, which is available on most resources. Some resources can only be deleted from the web interface.

Delete an epic
```ruby
client.epic(id: 123).delete!
```

Delete all stories in the 'Testing' project
```ruby
client.project(name: 'Testing').stories.each(&:delete!)
```

### Methods returning arrays of resources
```ruby
	client.projects 					# list all projects
	client.milestones 					# list all milestones
	client.members 						# list all members (users)
	client.epics 						# list all epics
	client.stories 						# list all stories, comments and tasks [WARNING: slow!]
	client.categories 					# list all categories
	client.workflows 					# list all workflows and states
	client.labels 						# list all labels
	client.teams 						# list all teams
	client.story_links					# list all story links
```
### Methods returning single resources
```ruby
	client.project 						# list the first matching project
	client.milestone 					# list the first matching milestone
	client.member 						# list the first matching member (user)
	client.epic 						# list the first matching epic
	client.story 						# list the first matching story [WARNING: slow!]
	client.category 					# list the first matching category
	client.workflow 					# list the first matching workflow (usually Default)
	client.label 						# list the first matching label
	client.team 						# list the first matching team
	client.story_link 					# list the first matching story link
```

### Creation methods
```ruby
	client.create_project 					# create a project
	client.create_milestone 				# create a milestone
	client.create_member 					# create a member
	client.create_epic 					# create an epic
	client.create_story 					# create a story
	client.create_category 					# create a category
	client.create_workflow 					# create a workflow
	client.create_label 					# create a label
	client.create_team 					# create a team
	client.create_story_link 			# create a story link
	client.story.create_comment			# create a comment for a story
	client.story.create_task			# create a task for a story
	client.epic.create_comment			# create a comment for an epic
```
### Update methods
```ruby
	client.update_project 					# update a project
	client.update_milestone 				# update a milestone
	client.update_member 					# update a member
	client.update_epic 					# update an epic
	client.update_story 					# update a story
	client.update_category 					# update a category
	client.update_workflow 					# update a workflow
	client.update_label 					# update a label
	client.update_team 					# update a team
	client.update_story_link 				# update a story link
```

### Filtering
It's possible to filter by any resource property provided by the API. Multiple property filters can be specified. Filters match any member of an array, for example you can filter `stories` by `follower_ids`, which will match any stories for which the given member, or members, are followers.
```ruby
	client.project(id: 123)				# get a specific project
	client.project(name: 'blah')		# get a project by name
	client.projects(archived: true) 	# get all archived projects
	client.project(id: 123).stories		# get stories belonging to a project
	client.story(archived: false)		# get all non-archived stories
```
### Notes
Note that querying for stories is quicker when performed on a Project, rather than using the `client.projects` method. This is because stories are only available as children of a project, so building the global story array requires making an API call to every project.