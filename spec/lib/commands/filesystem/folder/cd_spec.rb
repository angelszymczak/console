require 'spec_helper'

describe Console::Commands::Cd do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(cd: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'cd new_directory'
      include_examples 'valid', 'cd /'
      include_examples 'valid', 'cd ..'

      include_examples 'invalid by invalid path', 'cd unknow/new_directory'

      include_examples 'invalid by arguments', 'cd new_directory extra_argument'
      include_examples 'invalid by options', 'cd new_directory -invalid=option'

      include_examples 'allow', 'cd new_directory', %i[super regular read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "cd #{new_directory}" }

      before { expect(command).to be_valid }

      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:new_directory) { 'folder_level_1/folder_level_2/../folder_level_2' }

        it do
          expect do
            is_expected.to eq(folder_level_2.path)
          end.to change { Console::Filesystem.pwd }
        end
      end

      context 'with invalid namespace' do
        let(:new_directory) { 'folder_level_1/!#$%&' }

        it do
          expect do
            is_expected.to match(/Invalid.*.path/)
          end.not_to change { Console::Filesystem.pwd }
        end
      end
    end
  end
end
