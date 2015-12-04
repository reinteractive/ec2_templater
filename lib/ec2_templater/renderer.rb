require 'erubis'

module Ec2Templater
  class Renderer
    Result = Struct.new(:changed?, :content)

    def initialize(template, target)
      @template_renderer = Erubis::Eruby.new(template)
      @target = target
    end

    def call(vars)
      new_content = render(vars)
      changed = (target_content != new_content)
      write_target(new_content) if changed
      Result.new(changed, new_content)
    end

    private

    def render(vars)
      @template_renderer.evaluate(vars)
    end

    def target_content
      File.read(@target) if File.exist?(@target)
    end

    def write_target(content)
      File.write(@target, content)
    end
  end
end
