module Clubhouse
	module Helpers
		def resolve_to_ids(object)
			return object.collect { |o| self.resolve_to_ids(o) } if object.is_a? Array
			(object.respond_to?(:id) ? object.id : object)
		end
	end
end