require 'spec_helper'

describe Console::Commands::Login do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(login: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'login username password'

    include_examples 'invalid by arguments', 'login missing_argument'
    include_examples 'invalid by arguments', 'login username password extra_argument'
    include_examples 'invalid by options', 'login username password -extra=option'

    include_examples 'allow', 'login', %i[super regular read_only]

    context '#perform' do
      let(:input) { "login #{username} #{common_password}" }

      subject(:perform) { command.perform }

      context 'with know user' do
        let(:username) do
          Console::User
            .users
            .reject { |u| u == Console::User.current_user }
            .sample
            .username
        end

        after { expect(Console::User.current_user.username).to eq(username) }

        it do
          expect do
            is_expected.to match(/Logged.*.#{username}/)
          end.to change { Console::User.current_user }
        end
      end

      context 'with unknow user' do
        let(:username) { 'unknow_user' }

        it do
          expect do
            is_expected.to match(/Invalid Credentials./)
          end.not_to change { Console::User.current_user }
        end
      end
    end
  end
end
