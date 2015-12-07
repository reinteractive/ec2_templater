require 'aws-sdk'

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

  def self.wait_for_instance(client, instance_id)
    client.wait_until(:instance_running, instance_ids: [instance_id])
  end
end
