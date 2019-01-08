require 'spec_helper'
require 'pry'
require 'webmock/rspec'

module Clubhouse
	RSpec.shared_context 'clubhouse_resource' do
		describe '#property_filter_create' do
			it 'returns an array' do
				expect(described_class.property_filter_create).to be_instance_of(Array)
			end
		end

		describe '#property_filter_update' do
			it 'returns an array' do
				expect(described_class.property_filter_update).to be_instance_of(Array)
			end
		end

		describe '#properties' do
			it 'returns an array' do
				expect(described_class.property_filter_update).to be_instance_of(Array)
			end
		end
	end

	RSpec.shared_context 'queryable_resource' do
		describe '#self.api_url' do
			it 'returns a string or symbol' do
				expect(described_class.api_url).to be_instance_of(String).or be_instance_of(Symbol)
			end
		end

		describe '#api_url' do
			it 'returns a string or symbol' do
				expect(subject.api_url).to be_instance_of(String).or be_instance_of(Symbol)
			end

			it 'includes its own id' do
				subject.instance_variable_set(:@id, 'spec123')
				expect(subject.api_url).to include('spec123')
			end
		end
	end

	ClubhouseResource.all.each do |this_resource|
		RSpec.describe this_resource do
			it_behaves_like 'clubhouse_resource'

			if this_resource.ancestors.include?(Queryable)
				it_behaves_like 'queryable_resource'
			end
		end
	end

	RSpec.describe ClubhouseResource do
		describe '#self.subclass' do
			it 'finds and returns a subclass' do
				expect(ClubhouseResource.subclass('Story')).to eq(Clubhouse::Story)
			end
		end
	end

	RSpec.describe Helpers do
		describe '#resolve_to_ids' do
			it 'resolves a resource to its id' do
				a = Story.new
				a.instance_variable_set(:@id, 'spec123')
				expect(a.resolve_to_ids(a)).to eq('spec123')
			end

			it 'resolves an array of resources to their ids' do
				a = [ Story.new, Story.new ]
				a[0].instance_variable_set(:@id, 'spec123')
				a[1].instance_variable_set(:@id, 'spec456')
				expect(a[0].resolve_to_ids(a)).to eq([ 'spec123', 'spec456' ])
			end
		end
	end
end
