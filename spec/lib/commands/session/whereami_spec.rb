require 'spec_helper'

describe Console::Commands::Whereami do

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(whereami: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'whereami'

    include_examples 'invalid by arguments', 'whereami extra_argument'
    include_examples 'invalid by options', 'whereami -extra=option'

    include_examples 'allow', 'whereami', %i[super regular read_only]

    context '#perform' do
      include_context 'loaded tree'

      let(:input) { 'whereami' }

      subject(:perform) { command.perform }

      it { is_expected.to eq(Console::Filesystem.pwd.path) }

      context 'changing the path' do
        before { Console::Filesystem.pwd = folder_level_4 }

        it { is_expected.to eq(Console::Filesystem.pwd.path) }
      end
    end
  end
end
