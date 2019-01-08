module Clubhouse
	module Queryable
		def api_url
			self.class.api_url + "/#{@id}"
		end

		def initialize(client: nil, object: {})
			@client = client

			self.class.properties.each do |this_property|
				self.class.class_eval { attr_accessor(this_property.to_sym) }
				self.class.send(:define_method, (this_property.to_s + '=').to_sym) do |value|
					update({ this_property => resolve_to_ids(value) })
					instance_variable_set('@' + this_property.to_s, resolve_to_ids(value))
				end
			end

			set_properties(object)
			self
		end

		# Empties resource cache
		def flush
			@client.flush(self.class)
		end

		def update(args = {})
			new_params = args.reject { |k, v| self.class.property_filter_update.include? k.to_sym }
			validate(new_params)
			flush
			@client.api_request(:put, @client.url(api_url), :json => new_params)
		end

		def delete!
			flush
			@client.api_request(:delete, @client.url(api_url))
		end
	end
end