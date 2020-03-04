require 'spec_helper'

describe Console::Commands::Ls do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(ls: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'ls directory'
      include_examples 'valid', 'ls /'
      include_examples 'valid', 'ls ..'

      include_examples 'invalid by invalid path', 'ls unknow/directory'

      include_examples 'invalid by arguments', 'ls directory extra_argument'
      include_examples 'invalid by options', 'ls directory -invalid=option'

      include_examples 'allow', 'ls directory', %i[super regular read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "ls #{directory}" }

      before { expect(command).to be_valid }

      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:directory) { 'folder_level_1/folder_level_2/../folder_level_2' }

        it { is_expected.to eq(folder_level_2.items.map(&:name).join(' ')) }
      end

      context 'with invalid namespace' do
        let(:directory) { 'folder_level_1/!#$%&' }

        it { is_expected.to match(/Invalid.*.path/) }
      end
    end
  end
end
