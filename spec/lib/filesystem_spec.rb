require 'spec_helper'

describe Console::Filesystem do
  describe '.initial_filesystem' do
    subject(:directory) { described_class.initial_filesystem }

    it { is_expected.to be_root }
    it { expect(subject.name).to eq('/') }
    it { expect(subject.parent).to be_nil }
  end
end
