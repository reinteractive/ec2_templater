require 'spec_helper'

require 'aws-sdk'
require 'ec2_templater/filtered_ec2_list'

def client
  @client ||=
    Aws::EC2::Client.new(region: ENV.fetch('AWS_REGION', 'ap-southeast-2'))
end

describe 'Filtered Ec2 List on matching tags', :vcr do
  let(:filtered_ec2_list) { Ec2Templater::FilteredEc2List.new(client) }
  subject(:grouped_instances) { filtered_ec2_list.call(filters) }

  let(:filters) do
    { 'tag:Environment' => 'Staging',
      'tag:Role' => ['app'] }
  end

  specify { expect(grouped_instances.size).to be == 1 }

  context 'when filters do not match' do
    let(:filters) do 
      { 'tag:Environment' => 'Staging',
        'tag:Role' => ['db'] }
    end

    it { is_expected.to be_empty }
  end

end
