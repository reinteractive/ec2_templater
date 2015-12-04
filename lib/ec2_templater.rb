require 'ec2_templater/version'
require 'ec2_templater/runner'
require 'ec2_templater/monitor'
require 'ec2_templater/command_line'

module Ec2Templater
  def self.run(config)
    Monitor.new(Runner.new(config), config['interval']).run do
      system(config['notify_cmd'])
    end
  end
end