require 'spec_helper'

describe Console::Commands::Whoami do
  include_context 'Loaded store'

  it 'registered'  do
    expect(Console::Commands::Command.send(:commands)).to include(whoami: described_class)
  end

  describe '.build!' do
    subject(:command) { Console::Commands::Command.build!(input) }

    context 'valid input' do
      let(:input) { 'whoami' }

      include_examples 'Valid commands'

      context '#exec' do
        context 'allow for all roles' do
          it 'allow for all roles' do
            [super_user, regular_user, read_only_user].each do |user|
              Console::User.current_user = user
              is_expected.to be_allow
            end
          end

          context '#perform' do
            subject(:perform) { command.perform }

            it 'returns current user username' do
              is_expected.to eq(Console::User.current_user.username)
            end
          end
        end
      end
    end

    context 'invalid command' do
      before { is_expected.not_to be_valid }

      context 'by extra arguments' do
        let(:input) { 'whoami extra arg' }

        it { expect(subject.error_message).to match(/arguments.*.extra.*.arg.*./) }
      end

      context 'by extra options' do
        let(:input) { 'whoami -option=typo' }

        it { expect(subject.error_message).to match(/options.*.typo.*./) }
      end
    end
  end
end
