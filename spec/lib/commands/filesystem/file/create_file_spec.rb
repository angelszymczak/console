require 'spec_helper'

describe Console::Commands::CreateFile do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(create_file: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'create_file new_file content'
      include_examples 'valid', 'create_file new_file content -type=awesome'

      include_examples 'invalid by invalid namespace', 'create_file folder_level_1 content'
      include_examples 'invalid by invalid path', 'create_file unknow/new_file content'
      include_examples 'invalid by exceptional arguments', 'create_file / content'

      include_examples 'invalid by arguments', 'create_file'
      include_examples 'invalid by arguments', 'create_file missing_argument'
      include_examples 'invalid by arguments', 'create_file new_file content extra_argument'
      include_examples 'invalid by options', 'create_file new_file content -invalid=option'

      include_examples 'allow', 'create_file new_file', %i[super regular]
      include_examples 'not allow', 'create_file new_file', %i[read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "create_file #{new_file} content" }

      before { expect(command).to be_valid }

      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:new_file) { 'folder_level_1/folder_level_2/new_file' }

        it do
          expect do
            is_expected.to match(/Folder.*.was created/)
          end.to change { folder_level_2.items.count }.by(1)
        end
      end

      context 'with invalid namespace' do
        let(:new_file) { 'folder_level_1/!#$%&' }

        it do
          expect do
            is_expected.to match(/Invalid format name/)
          end.not_to change { folder_level_2.items.count }
        end
      end
    end
  end
end
