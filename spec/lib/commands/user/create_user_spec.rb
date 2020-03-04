require 'spec_helper'

describe Console::Commands::CreateUser do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(create_user: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'create_user new_username new_password -role=regular'

    include_examples 'invalid by arguments', 'create_user'
    include_examples 'invalid by arguments', 'create_user username password extra_argument'
    include_examples 'invalid by options', 'create_user username password -invalid=option'
    include_examples 'invalid by options', 'create_user username password -role=regular -extra=option'

    include_examples 'allow', 'create_user', %i[super]

    include_examples 'not allow', 'create_user', %i[regular read_only]

    context '#perform' do
      let(:input) { "create_user #{username} password -role=read_only" }

      subject(:perform) { command.perform }

      context 'with new username' do
        let(:username) { 'new_user'}

        before { expect(Console::User.find_by(username)).to be_nil }
        after { expect(Console::User.find_by(username)).not_to be_nil }

        it do
          expect do
            is_expected.to match(/User \[#{username}:read_only\] was created./)
          end.to change { Console::User.users.count }.by(1)
        end
      end

      context 'with taken username' do
        let(:username) { super_user.username }

        before { expect(Console::User.find_by(username)).to be(super_user) }

        it do
          expect do
            is_expected.to match(/Username \[#{username}\] has been taken./)
          end.not_to change { Console::User.users.count }
        end
      end
    end
  end
end
