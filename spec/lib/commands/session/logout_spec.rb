require 'spec_helper'

describe Console::Commands::Logout do
  include_context 'Loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(logout: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'valid input' do
      let(:input) { 'logout' }

      it { is_expected.to be_a(described_class) }
      it { is_expected.to be_valid }
      it { is_expected.to be_valid_arguments }
      it { is_expected.to be_valid_options }

      context '#exec' do
        it 'allow for all roles' do
          [super_user, regular_user, read_only_user].each do |user|
            Console::User.current_user = user

            is_expected.to be_allow
          end
        end

        context '#perform' do
          before { allow(subject).to receive(:exit_session) }

          it '#perform' do
            expect(STDOUT).to receive(:puts).with(/Ok, ok, I'm out. Bye/)
            expect(subject).to receive(:exit_session)

            subject.perform
          end
        end
      end
    end

    context 'invalid command' do
      before { is_expected.not_to be_valid }

      context 'by extra arguments' do
        let(:input) { 'logout extra_arg' }

        it { expect(subject.error_message).to match(/arguments.*.extra.*.arg.*./) }
      end

      context 'by extra options' do
        let(:input) { 'logout -option=typo' }

        it { expect(subject.error_message).to match(/options.*.typo.*./) }
      end
    end
  end
end
