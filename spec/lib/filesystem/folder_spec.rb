require 'spec_helper'

describe Console::Folder do
  describe '.new' do
    subject(:folder) { described_class.new('name') }

    it { is_expected.to be_folder }
  end
end
