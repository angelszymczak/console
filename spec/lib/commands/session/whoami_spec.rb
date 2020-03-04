require 'spec_helper'

describe Console::Commands::Whoami do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(whoami: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'whoami'

    include_examples 'invalid by arguments', 'whoami extra_argument'
    include_examples 'invalid by options', 'whoami -extra=option'

    include_examples 'allow', 'whoami', %i[super regular read_only]

    context '#perform' do
      let(:input) { 'whoami' }

      subject(:perform) { command.perform }

      it { is_expected.to eq(Console::User.current_user.username) }
    end
  end
end
