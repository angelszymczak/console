require 'spec_helper'

describe Console::Commands::Login do
  include_context 'Loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(login: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'valid input' do
      let(:input) { 'login any_username any_password' }

      it { is_expected.to be_a(described_class) }
      it { is_expected.to be_valid }
      it { is_expected.to be_valid_arguments }
      it { is_expected.to be_valid_options }

      context '#exec' do
        context 'allow for all roles' do
          it 'allow for all roles' do
            [super_user, regular_user, read_only_user].each do |user|
              Console::User.current_user = user
              is_expected.to be_allow
            end
          end

          context '#perform' do
            let(:input) { "login #{username} #{password}" }

            context 'with know user' do
              let(:username) { regular_user.username }
              let(:password) { regular_user_password }

              subject(:perform) { command.perform }

              it '#perform' do
                expect do
                  is_expected.to match(/Logged.*.#{username}/)
                  expect(Console::User.current_user).to eq(regular_user)
                end.to change { Console::User.current_user }
              end
            end

            context 'with unknow user' do
              let(:username) { 'unknow_user' }
              let(:password) { 'some_pass' }

              subject(:perform) { command.perform }

              it '#perform' do
                expect do
                  is_expected.to match(/Invalid Credentials./)
                end.not_to change { Console::User.current_user }
              end
            end
          end
        end
      end
    end

    context 'invalid command' do
      context 'bad arguments' do
        let(:input) { 'login' }

        it { is_expected.not_to be_valid }

        context '#error_message' do
          before { subject.valid? }

          it { expect(subject.error_message).to match(/arguments/) }
        end
      end

      context 'bad arguments' do
        let(:input) { 'login username password typo' }

        it { is_expected.not_to be_valid }

        context '#error_message' do
          before { subject.valid? }

          it { expect(subject.error_message).to match(/arguments.*.typo.*./) }
        end
      end

      context 'bad opions' do
        let(:input) { 'login username password -option=typo' }

        it { expect { subject }.to raise_error(Console::Commands::MalFormed, /.-option=typo./) }
      end
    end
  end
end
