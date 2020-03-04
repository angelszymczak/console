require 'spec_helper'

describe Console::Commands::Logout do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(logout: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'logout'

    include_examples 'invalid by arguments', 'logout extra_argument'
    include_examples 'invalid by options', 'logout -extra=option'

    include_examples 'allow', 'logout', %i[super regular read_only]

    context '#perform' do
      let(:input) { 'logout' }

      before { allow(subject).to receive(:exit_session) }

      it do
        expect(STDOUT).to receive(:puts).with(/Ok, ok, I'm out. Bye/)
        expect(subject).to receive(:exit_session)

        subject.perform
      end
    end
  end
end
