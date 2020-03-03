require 'spec_helper'

describe Console::Commands::UpdatePasswordUser do
  include_context 'loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(update_password: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    include_examples 'valid', 'update_password new_password'

    include_examples 'invalid by wrong arguments', 'update_password'
    include_examples 'invalid by wrong arguments', 'update_password new_password extra_argument'
    include_examples 'invalid by wrong options', 'update_password new_password -invalid=option'

    include_examples 'allow', 'update_password', %i[super regular read_only]

    context '#perform' do
      let(:input) { "update_password #{new_password}" }
      let(:user) { Console::User.current_user }

      subject(:perform) { command.perform }

      context 'with valid password' do
        let(:new_password) { 'valid_long_password' }

        it do
          expect do
            is_expected.to match(/User \[#{user.username}:#{user.role}\] password updated./)
          end.to change { user.password }
        end
      end

      context 'with invalid password' do
        let(:new_password) { 'short' }

        it do
          expect do
            is_expected.to match(/Password must have \[8\] characters./)
          end.not_to change { user.password }
        end
      end
    end
  end
end
