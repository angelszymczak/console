require 'spec_helper'

describe Console::User do
  describe '.new' do
    before { ENV['SECRET'] = 'secret' }

    context 'valid profile' do
      let(:username) { 'username' }
      let(:password) { 'password' }

      subject(:user) { described_class.new(username, password, :super) }

      it { is_expected.to be_valid_profile }
      it { is_expected.to be_valid_username_size }
      it { is_expected.to be_valid_password }

      context 'password was encrypted' do
        before { subject.valid_profile? }

        it { expect(subject.password).not_to eq(password) }
      end
    end

    context 'invalid profile by' do
      before { is_expected.not_to be_valid_profile }

      context 'username' do
        subject(:user) { described_class.new(username, 'password', :super) }

        context 'too long' do
          let(:username) { 'large' * 100 }

          it { expect(user.error_message).to eq('Username size must be in [255..8] by [500].') }
        end

        context 'too short' do
          let(:username) { 'short' }

          it { expect(user.error_message).to eq('Username size must be in [255..8] by [5].') }
        end

        context 'whit whitespaces' do
          let(:username) { 'user name' }

          it { expect(user.error_message).to eq('Username can\'t have whitespaces.') }
        end
      end

      context 'password' do
        subject(:user) { described_class.new('username', password, :super) }

        context 'to short' do
          let(:password) { 'pass' }

          it { expect(user.error_message).to eq('Password must have [8] characters.') }
        end

        context 'whit whitespaces' do
          let(:password) { 'pass word' }

          it { expect(user.error_message).to eq('Password can\'t have whitespaces.') }
        end
      end

      context 'role' do
        subject(:user) { described_class.new('username', 'password', :none) }

        it { expect(user.error_message).to eq('Invalid [none] role.') }
      end
    end
  end

  describe 'roles' do
    subject(:user) { described_class.new('superuser', 'password', role) }

    context 'super' do
      let(:role) { :super }

      it { is_expected.to be_super }
      it { expect(subject.symbol).to eq('#') }
    end

    context 'regular' do
      let(:role) { :regular }

      it { is_expected.to be_regular }
      it { expect(subject.symbol).to eq('$') }
    end

    context 'read only' do
      let(:role) { :read_only}

      it { is_expected.to be_read_only }
      it { expect(subject.symbol).to eq('>') }
    end
  end

  describe '.create' do
    include_context 'loaded store'

    subject(:new_user) { described_class.create(username, common_password, :regular) }

    context 'when new user' do
      let(:username) { 'new_user' }

      it do
        expect do
          is_expected.to be_valid
        end.to change { described_class.users.count }.by(1)
      end
    end

    context 'when taken user' do
      let(:username) { described_class.users.sample.username }

      it do
        expect do
          is_expected.not_to be_valid
        end.not_to change { described_class.users.count }
      end
    end
  end

  describe '.update_password' do
    include_context 'loaded store'

    subject(:updated_user) { described_class.update_password(password) }

    context 'when valid upated password' do
      let(:password) { 'updated_password' }

      it do
        expect do
          is_expected.to be_valid
        end.to change { described_class.current_user.password }
      end
    end

    context 'when invalid upated password' do
      let(:password) { 'invalid' }

      it do
        expect do
          is_expected.not_to be_valid
        end.not_to change { described_class.current_user.password }
      end
    end
  end

  describe '.destroy' do
    include_context 'loaded store'

    subject(:target_user) { described_class.destroy(username) }

    context 'when user exists' do
      let(:user) { described_class.users.sample }
      let(:username) { user.username }

      before { expect(described_class.find_by(username)).to be(user) }
      after { expect(described_class.find_by(username)).to be_nil }

      it do
        expect do
          is_expected.to eq(user)
        end.to change { described_class.users.count }.by(-1)
      end
    end

    context 'when user not exists' do
      let(:username) { 'unknown' }

      it do
        expect do
          is_expected.to be_nil
        end.not_to change { described_class.users.count }
      end
    end
  end

  describe '.find_by' do
    include_context 'loaded store'

    subject(:target) { described_class.find_by(username) }

    context 'when user exists' do
      let(:username) { described_class.users.sample.username }

      it { is_expected.to have_attributes(username: username) }
    end

    context 'when user not exists' do
      let(:username) { 'unknown' }

      it { is_expected.to be_nil }
    end
  end

  describe '.login' do
    include_context 'loaded store'

    subject(:logged_user) { described_class.login(username, common_password) }

    context 'when user exists' do
      let(:username) do
        described_class
          .users
          .reject { |u| u == described_class.current_user }
          .sample
          .username
      end

      it do
        expect do
          is_expected.to eq(described_class.current_user)
        end.to change { described_class.current_user }
      end
    end

    context 'when user not exists' do
      let(:username) { 'unknown' }

      it do
        expect do
          is_expected.to be_nil
        end.not_to change { described_class.current_user }
      end
    end
  end

  describe '.logged?' do
    include_context 'loaded store'

    subject(:user) { described_class.logged?(username) }

    context 'when is current user' do
      let(:username) { described_class.current_user.username }

      it { is_expected.to be_truthy }
    end

    context 'when is not current user' do
      let(:username) { 'another' }

      it { is_expected.to be_falsey }
    end
  end
end
