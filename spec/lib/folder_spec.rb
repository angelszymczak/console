require 'spec_helper'

describe Console::Folder do
  describe '.initial_filesystem' do
    subject(:directory) { described_class.initial_filesystem }

    it { expect(subject.name).to eq('/') }
  end
end
