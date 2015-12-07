$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'
require 'aws_helpers'
require 'pry'

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
  c.default_cassette_options = { record: :all }
end


RSpec.configure do |config|
  config.add_setting :instance_id

  config.before(:suite) do
    VCR.use_cassette 'ec2_run_instance' do
      instance_id = AwsHelpers.start_instance(client, 'the_adam')
      RSpec.configuration.instance_id = instance_id

      instance = Aws::EC2::Instance.new(id: instance_id, client: client)
      instance.create_tags(tags: [
        { key: 'Environment', value: 'Staging' },
        { key: 'Role', value: 'app' }
      ])
    end
  end

  config.after(:suite) do
    VCR.use_cassette 'ec2_terminate_instance' do
      instance_id = RSpec.configuration.instance_id
      client.terminate_instances(instance_ids: [instance_id])
    end
  end
end

