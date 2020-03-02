require 'spec_helper'

describe Console::Commands::CreateUser do
  include_context 'Loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(create_user: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'valid input' do
      let(:input) { 'create_user new_username new_password -role=regular' }

      include_examples 'Valid commands'

      context '#exec' do
        context 'super user allow to create new user' do
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

        context '#perform' do
          let(:input) { "create_user #{username} password -role=read_only" }

          subject(:perform) { command.perform }

          context 'with new username' do
            let(:username) { 'this_is_a_new_user'}

            it do
              expect(Console::User.find_by(username)).to be_nil

              expect do
                is_expected.to match(/User \[#{username}:read_only\] was created./)
                expect(Console::User.find_by(username)).not_to be_nil
              end.to change { Console::User.users.count }.by(1)
            end
          end

          context 'with taken username' do
            let(:username) { super_user.username }

            it do
              expect(Console::User.find_by(username)).not_to be_nil

              expect do
                is_expected.to match(/Username \[#{username}\] has been taken./)
              end.not_to change { Console::User.users.count }
            end
          end
        end
      end
    end

    context 'invalid command' do
      before { is_expected.not_to be_valid }

      context 'missing arguments' do
        let(:input) { 'create_user' }

        it { expect(subject.error_message).to match(/arguments/) }
      end

      context 'by extra arguments' do
        let(:input) { 'create_user username password extra arg' }

        it { expect(subject.error_message).to match(/arguments.*.extra.*.arg.*./) }
      end

      context 'by extra options' do
        let(:input) { 'create_user username password -extra_option_1=typo_1 -option=typo' }

        it { expect(subject.error_message).to match(/options.*.typo.*./) }
      end

      context 'bad options' do
        let(:input) { 'create_user username password -option=typo' }

        it { expect(subject.error_message).to match(/options: Expected -role flag/) }
      end
    end
  end
end
