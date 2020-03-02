require 'spec_helper'

describe Console::Commands::DestroyUser do
  include_context 'Loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(destroy_user: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'valid input' do
      let(:input) { 'destroy_user anybody' }

      include_examples 'Valid commands'

      context '#exec' do
        context 'super user allow to destroy' do
          before { Console::User.current_user = super_user }

          it { is_expected.to be_allow }
        end

        it 'if not super user not allow to create new user' do
          [regular_user, read_only_user].each do |user|
            Console::User.current_user = regular_user

            is_expected.not_to be_allow
            expect(subject.error_message).to match(/permissions: There aren't enough permissions/)
          end
        end
      end

      context '#perform' do
        before { Console::User.current_user = super_user }

        let(:input) { "destroy_user #{username}" }

        subject(:perform) { command.perform }

        context 'when not exist' do
          let(:username) { 'unknow_user'}

          it do
            expect(Console::User.find_by(username)).to be_nil

            expect do
              is_expected.to match(/Can't destroy \[#{username}\]./)
            end.not_to change { Console::User.users.count }
          end
        end

        context 'when try delete itself' do
          let(:username) { Console::User.current_user.username }

          it do
            expect(Console::User.find_by(username)).not_to be_nil

            expect do
              is_expected.to match(/Can't destroy current logged user./)
            end.not_to change { Console::User.users.count }
          end
        end

        context 'with know username and not logged' do
          before { Console::User.users << target_user }

          let(:target_user) { Console::User.new('target_user', 'password', :regular) }
          let(:username) { target_user.username }

          it do
            expect(Console::User.find_by(username)).not_to be_nil

            expect do
              is_expected.to match(/User \[#{username}\] was destroyed./)
            end.to change { Console::User.users.count }.by(-1)
          end
        end
      end
    end

    context 'invalid command' do
      before { is_expected.not_to be_valid }

      context 'missing arguments' do
        let(:input) { 'destroy_user' }

        it { expect(subject.error_message).to match(/arguments/) }
      end

      context 'by extra arguments' do
        let(:input) { 'destroy_user username extra arg' }

        it { expect(subject.error_message).to match(/arguments.*.extra.*.arg.*./) }
      end

      context 'by extra options' do
        let(:input) { 'destroy_user username -extra_option_1=typo_1 -option=typo' }

        it { expect(subject.error_message).to match(/options.*.typo.*./) }
      end
    end
  end
end
