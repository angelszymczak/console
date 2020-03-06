require 'spec_helper'

describe Console::Commands::Destroy do
  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(destroy: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'validations' do
      include_context 'loaded tree'

      include_examples 'valid', 'destroy folder_level_1'

      include_examples 'invalid by exceptional arguments', 'destroy /'

      include_examples 'invalid by arguments', 'destroy'
      include_examples 'invalid by arguments', 'destroy folder_level_1 extra_argument'
      include_examples 'invalid by options', 'destroy folder_level_1 -invalid=option'

      include_examples 'allow', 'destroy target', %i[super regular]
      include_examples 'not allow', 'destroy target', %i[read_only]
    end

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { "destroy #{target}" }


      subject(:perform) { command.perform }

      context 'with valid namespace' do
        let(:target) { 'folder_level_1/folder_level_2' }

        before { expect(command).to be_valid }

        it do
          expect do
            is_expected.to match(/Item.*.was destroyed/)
          end.to change { folder_level_1.items.count }.by(-1)
        end
      end
    end
  end
end
