require 'aws-sdk'

module Ec2Templater
  class FilteredEc2List
    # Provide an awssdk v2 client
    def initialize(client = Aws::EC2::Client.new)
      @client = client
    end

    # Return list of instances that match the provided filters.
    #
    # The filters match those defined for the describe-instances api call.
    # http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html
    #
    # The returned instances are <Types::Instance> from awssdk. See:
    # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Types/Instance.html
    #
    # Filter Examples:
    #   { "tag:Name" => "", "vpc-id" => "vpc-9321c9a2" }
    #   { "tag:Environment" => "Production" }
    def call(filters = {})
      args = { filters: processed_filters(default_filters.merge(filters)) }
      @client.describe_instances(args).reservations.flat_map(&:instances)
    end

    def [](filters = {})
      call(filters)
    end

    def processed_filters(filters)
      filters.map do |key, value|
        { name: key, values: Array(value) }
      end
    end

    def default_filters
      { 'instance-state-name' => 'running' }
    end
  end
end
