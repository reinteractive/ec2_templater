require 'ec2_templater/renderer'
require 'ec2_templater/ec2_grouper'

module Ec2Templater
  class Runner
    def initialize(config)
      @vars = config.fetch('vars', {})
      @renderer = Renderer.new(File.read(config['template']), config['target'])
      @ec2_grouper = Ec2Grouper.new(config['groups'])
    end

    def call
      @renderer.call(vars)
    end

    def vars
      @vars.merge(groups: @ec2_grouper.call)
    end
  end
end
