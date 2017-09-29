module Clubhouse
	class ClubhouseValidationError < StandardError
		def initialize(message)
			super('validation error: %s' % message)
		end
	end

	class ClubhouseAPIError < StandardError
		def initialize(response)
			super('api error (%d): %s' % [ response.code, response.to_s ])
		end
	end

	class NoSuchMember < ClubhouseValidationError
		def initialize(member)
			super('no such member (%s)' % member)
		end
	end

	class NoSuchFile < ClubhouseValidationError
		def initialize(file)
			super('no such file (%s)' % file)
		end
	end

	class NoSuchLinkedFile < ClubhouseValidationError
		def initialize(file)
			super('no such linked file (%s)' % file)
		end
	end

	class NoSuchTeam < ClubhouseValidationError
		def initialize(team)
			super('no such team (%s)' % team)
		end
	end

	class NoSuchProject < ClubhouseValidationError
		def initialize(project)
			super('no such project (%s)' % project)
		end
	end

	class NoSuchMilestone < ClubhouseValidationError
		def initialize(milestone)
			super('no such milestone (%s)' % milestone)
		end
	end

	class NoSuchEpic < ClubhouseValidationError
		def initialize(epic)
			super('no such epic (%s)' % epic)
		end
	end
end