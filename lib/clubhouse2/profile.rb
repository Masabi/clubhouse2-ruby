module Clubhouse
	class Profile < ClubhouseResource
		def self.properties
			[ :deactivated, :name, :mention_name, :email_address, :gravatar_hash, :display_icon, :two_factor_auth_activated ]
		end
	end
end
