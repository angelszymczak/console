require 'spec_helper'

describe Console::Commands::DestroyUser do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(destroy_user: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'destroy_user username'

    include_examples 'invalid by wrong arguments', 'destroy_user'
    include_examples 'invalid by wrong arguments', 'destroy_user username extra_argument'
    include_examples 'invalid by wrong options', 'destroy_user username -invalid=option'

    include_examples 'allow', 'destroy_user', %i[super]

    include_examples 'not allow', 'destroy_user', %i[regular read_only]

    context '#perform' do
      before { Console::User.current_user = super_user }

      let(:input) { "destroy_user #{username}" }

      subject(:perform) { command.perform }

      context 'when not exist' do
        let(:username) { 'unknow_user'}

        before { expect(Console::User.find_by(username)).to be_nil }

        it do
          expect do
            is_expected.to match(/Can't destroy \[#{username}\]./)
          end.not_to change { Console::User.users.count }
        end
      end

      context 'when try to delete himself' do
        let(:username) { Console::User.current_user.username }

        before { expect(Console::User.find_by(username)).to be(Console::User.current_user) }

        it do
          expect do
            is_expected.to match(/Can't destroy current logged user./)
          end.not_to change { Console::User.users.count }
        end
      end

      context 'with know username and he is not himself' do
        let(:user) { Console::User.users.reject { |u| u == Console::User.current_user }.sample }
        let(:username) { user.username }

        before { expect(Console::User.find_by(username)).to be(user) }
        after { expect(Console::User.find_by(username)).to be_nil }

        it do
          expect do
            is_expected.to match(/User \[#{username}\] was destroyed./)
          end.to change { Console::User.users.count }.by(-1)
        end
      end
    end
  end
end
