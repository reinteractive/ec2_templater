require 'spec_helper'

require 'aws-sdk'
require 'ec2_templater/filtered_ec2_list'

def client
  @client ||=
    Aws::EC2::Client.new(region: ENV.fetch('AWS_REGION', 'ap-southeast-2'))
end

describe 'Filtered Ec2 List in an empty account', :vcr do
  let(:filtered_ec2_list) { Ec2Templater::FilteredEc2List.new(client) }
  subject(:grouped_instances) { filtered_ec2_list.call(filters) }

  let(:filters) { {} }
  it { is_expected.to be_empty }

  context 'when an untagged EC2 intance is running' do
    before(:all) do
      VCR.use_cassette 'ec2_run_instance' do
        @instance_id = AwsHelpers.start_instance(client, 'the_adam')
        @instance = Aws::EC2::Instance.new(id: @instance_id, client: client)
      end
    end

    after(:all) do
      VCR.use_cassette 'ec2_terminate_instance' do
        client.terminate_instances(instance_ids: [@instance_id])
      end
    end

    specify { expect(grouped_instances.size).to be == 1 }

    context 'when filtering on tagged tags' do
      let(:filters) do
        { 'tag:primary' => 'one',
          'tag:secondary' => ['two'] }
      end
      it { is_expected.to be_empty }

      context 'which is then tagged' do
        before do
          @instance.create_tags(tags: [
            { key: 'primary', value: 'one' },
            { key: 'secondary', value: 'two' }
          ])
        end
        specify { expect(grouped_instances.size).to be == 1 }
      end
    end
  end
end
