# Clubhouse API v2 Ruby Gem

This is a resource-oriented ruby library for interacting with the Clubhouse v2 API. 

## How to use

### Initializing the client
```ruby
require 'clubhouse2'
client = Clubhouse::Client.new(api_key: 'your_api_key')
```

### Quick-start
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
```
### Filtering
It's possible to filter by any resource property provided by the API. Multiple property filters can be specified.
```ruby
	client.project(id: 123)				# get a specific project
	client.project(name: 'blah')		# get a project by name
	client.projects(archived: true) 	# get all archived projects
	client.project(id: 123).stories		# get stories belonging to a project
	client.story(archived: false)		# get all non-archived stories
```
### Notes
Note that querying for stories is quicker when performed on a Project, rather than using the `client.projects` method. This is because stories are only available as children of a project, so building the global story array requires making an API call to every project.