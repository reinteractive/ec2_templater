$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [:uri, :body, :method]
  }
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
  c.default_cassette_options = { record: :none }
end

module AwsHelpers
  def self.start_instance(client, key_pair_name)
    run_instance_response = client.run_instances(
      image_id: 'ami-187a247b', # ubuntu 14.04
      instance_type: 't2.micro', min_count: 1, max_count: 1,
      key_name: key_pair_name
    )

    instance_id = run_instance_response.instances[0].instance_id
    wait_for_instance(client, instance_id)
    instance_id
  end

  # Wait for 0 second for when vcr is running, then standard 30s delay if fails
  def self.wait_for_instance(client, instance_id)
    client.wait_until(:instance_running, instance_ids: [instance_id]) do |w|
      w.delay = 0
    end
  rescue Waiters::Errors::WaiterFailed
    client.wait_until(:instance_running, instance_ids: [instance_id])
  end
end
