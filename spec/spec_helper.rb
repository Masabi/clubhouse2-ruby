require 'rspec'

RSpec.configure do |config|
	config.requires = [ File.join(File.expand_path("../../lib/clubhouse2", __FILE__)) ]
    config.formatter = :documentation
    config.fail_fast = true
end
