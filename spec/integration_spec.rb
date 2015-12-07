require 'spec_helper'

require 'yaml'
require 'ec2_templater/runner'

ENV['AWS_REGION'] ||= 'ap-southeast-2'

describe 'Executing ec2_templater with example config', :vcr do
  let(:target) { '/tmp/ec2_templated.haproxy.cfg' }
  before do
    File.delete(target) if File.exist?(target)
    runner = Ec2Templater::Runner.new(YAML.load_file("example/config.yml"))
    runner.call
  end

  it 'will write the rendered template' do
    expect(File.exist?(target)).to be true
    expect(File.read(target)).to include "backend staging-app"
    expect(File.read(target)).to include "use_backend staging-app"
  end
end
