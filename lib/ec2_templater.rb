require 'ec2_templater/version'
require 'ec2_templater/runner'
require 'ec2_templater/monitor'
require 'ec2_templater/command_line'

module Ec2Templater
  def self.run(config)
    monitor = Monitor.new(Runner.new(config), config['interval'])
    monitor.run do
      system(config['notify_cmd'])
    end
    monitor
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = 'ec2_templater'
    end
  end
end
