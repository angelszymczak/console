require 'spec_helper'

describe Console::Commands::Metadata do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(metadata: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'metadata file_level_1'

      include_examples 'invalid by exceptional arguments', 'metadata /'
      include_examples 'invalid by exceptional arguments', 'metadata file_level_1/'

      include_examples 'invalid by arguments', 'metadata'
      include_examples 'invalid by arguments', 'metadata file_level_1 extra_argument'
      include_examples 'invalid by options', 'metadata file_level_1 -invalid=option'

      include_examples 'allow', 'metadata target', %i[super regular read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "metadata #{target}" }


      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:target) { 'folder_level_1/folder_level_2/item_1_level_2' }

        before { expect(command).to be_valid }

        it { is_expected.to match(item_1_level_2.metadata.to_s) }
      end
    end
  end
end
