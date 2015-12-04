require 'spec_helper'

require 'tempfile'
require 'ec2_templater/renderer'

describe 'Renderer' do
  let(:template) { '<%= @var %>' }
  let(:target) { Tempfile.new('/tmp') }
  subject(:renderer) { Ec2Templater::Renderer.new(template, target) }

  it { is_expected.to be_a(Ec2Templater::Renderer) }

  context 'when called with a var set' do
    let(:vars) { { var: 'test' } }
    let!(:result) { renderer.call(vars) }

    it 'will return a changed status' do
      expect(result).to be_changed
    end

    it 'will render the var' do
      expect(result.content).to be == 'test'
    end

    it 'will write the target file' do
      expect(File.read(target)).to be == 'test'
    end

    context 'when rendered again' do
      let!(:secondary_result) { renderer.call(vars) }

      it 'will return a NOT changed status' do
        expect(secondary_result).to_not be_changed
      end
    end
  end
end
