require 'spec_helper'

describe Console::Commands::CreateFolder do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(create_folder: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'create_folder new_folder'

      include_examples 'invalid by invalid namespace', 'create_folder folder_level_1'
      include_examples 'invalid by invalid path', 'create_folder unknow/new_folder'
      include_examples 'invalid by exceptional arguments', 'create_folder /'

      include_examples 'invalid by arguments', 'create_folder'
      include_examples 'invalid by arguments', 'create_folder new_folder extra_argument'
      include_examples 'invalid by options', 'create_folder new_folder -invalid=option'

      include_examples 'allow', 'create_folder new_folder', %i[super regular]
      include_examples 'not allow', 'create_folder new_folder', %i[read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "create_folder #{new_folder}" }

      before { expect(command).to be_valid }

      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:new_folder) { 'folder_level_1/folder_level_2/new_folder' }

        it do
          expect do
            is_expected.to match(/Folder.*.was created/)
          end.to change { folder_level_2.items.count }.by(1)
        end
      end

      context 'with invalid namespace' do
        let(:new_folder) { 'folder_level_1/!#$%&' }

        it do
          expect do
            is_expected.to match(/Invalid format name/)
          end.not_to change { folder_level_2.items.count }
        end
      end
    end
  end
end
