require 'ec2_templater/filtered_ec2_list'

module Ec2Templater
  class Ec2Grouper
    # Provide a hash of groupnames to filters
    def initialize(groups)
      @filtered_ec2_list = FilteredEc2List.new
      @groups = groups
    end

    # Returns a hash of groupnames to ec2 instance objects
    def call
      Hash[
        @groups.map do |group_name, filters|
          [group_name.to_sym, @filtered_ec2_list.call(filters)]
        end
      ]
    end
  end
end
