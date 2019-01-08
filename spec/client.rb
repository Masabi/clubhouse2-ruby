require 'spec_helper'
require 'pry'
require 'webmock/rspec'

WebMock.disable_net_connect!

module Clubhouse
	RSpec.describe Client do

		describe '#api_request' do
			before(:each) do
			end

			it 'raises an error when an unexpected code is returned' do
				stub_request(:post, /spec_endpoint_500/).
					to_return(status: 500, body: "stubbed error response", headers: {})
				a = Client.new(api_key: '12345', base_url: 'http://spec_endpoint_500')
				expect {
					a.api_request(:post, a.url('spec_path'))
				}.to raise_error(ClubhouseAPIError)
			end

			it 'retries when throttled' do
				stub_request(:post, /spec_endpoint_429/).
					to_return(status: 429, body: "stubbed error response", headers: {})
				a = Client.new(api_key: '12345', base_url: 'http://spec_endpoint_429')
				allow(a).to receive(:sleep)
				expect(a).to receive(:sleep).with(30)
				a.api_request(:post, a.url('spec_path'))
				expect(a_request(:post, /spec_endpoint_429/)).to have_been_made.times(3)
			end
		end

		describe '#flush' do
			it 'empties the resource array' do
				a = Client.new(api_key: '12345')
				a.instance_variable_set(:@resources, { spec_class: [:a, :b, :c] })
				a.flush(:spec_class)
				expect(a.instance_variable_get(:@resources)[:spec_class]).to be_nil
			end
		end

		describe '#url' do
			it 'correctly forms an api url' do
				a = Client.new(api_key: '12345', base_url: 'http://spec')
				expect(a.url('spec_endpoint').to_s).to eq('http://spec/spec_endpoint?token=12345')
			end
		end
	end
end
