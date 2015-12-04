require 'clamp'
require 'yaml'

module Ec2Templater
  class CommandLine < Clamp::Command
    option ['-c', '--config'],
           'CONFIG',
           'Path to config file in YAML format',
           required: true

    def execute
      validate_config_exists(config)
      loaded_config = YAML.load_file(config)
      Ec2Templater.run(loaded_config)
    end

    def validate_config_exists(config)
      return if File.exist?(config)
      signal_usage_error "Config at #{config} doesn't exist"
    end
  end
end
