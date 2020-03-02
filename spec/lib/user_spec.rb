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
      context 'username' do
        let(:password) { 'password' }

        context 'too long' do
          let(:username) { 'large' * 100 }

          subject(:user) { described_class.new(username, password, :super) }

          it do
            is_expected.not_to be_valid_profile
            expect(user.error_message).to eq('Username size must be in [255..8] by [500].')
          end
        end

        context 'too short' do
          let(:username) { 'short' }

          subject(:user) { described_class.new(username, password, :super) }

          it do
            is_expected.not_to be_valid_profile
            expect(user.error_message).to eq('Username size must be in [255..8] by [5].')
          end
        end

        context 'whit whitespaces' do
          let(:username) { 'user name' }

          subject(:user) { described_class.new(username, password, :super) }

          it do
            is_expected.not_to be_valid_profile
            expect(user.error_message).to eq('Username can\'t have whitespaces.')
          end
        end
      end

      context 'password' do
        let(:username) { 'username' }

        context 'to short' do
          let(:password) { 'pass' }

          subject(:user) { described_class.new(username, password, :super) }

          it do
            is_expected.not_to be_valid_profile
            expect(user.error_message).to eq('Password must have [8] characters.')
          end
        end

        context 'whit whitespaces' do
          let(:password) { 'pass word' }

          subject(:user) { described_class.new(username, password, :super) }

          it do
            is_expected.not_to be_valid_profile
            expect(user.error_message).to eq('Password can\'t have whitespaces.')
          end
        end
      end

      context 'role' do
        subject(:user) { described_class.new('username', 'password', :none) }

        it do
          is_expected.not_to be_valid_profile
          expect(user.error_message).to eq('Invalid [none] role.')
        end
      end
    end
  end

  describe 'roles' do
    subject(:user) { described_class.new('superuser', 'password', role) }

    context 'super' do
      let(:role) { :super }

      it do
        is_expected.to be_super
        expect(subject.symbol).to eq('#')
      end
    end

    context 'regular' do
      let(:role) { :regular }

      it do
        is_expected.to be_regular
        expect(subject.symbol).to eq('$')
      end
    end

    context 'read only' do
      let(:role) { :read_only}

      it do
        is_expected.to be_read_only
        expect(subject.symbol).to eq('>')
      end
    end
  end

  describe '.login' do
    let(:store) do
      instance_double(
        Console::Store,
        users: [
          described_class.new('username_1', 'password_1', :super),
          described_class.new('username_2', 'password_2', :regular)
        ]
      )
    end

    before { described_class.store = store }

    subject(:user) { described_class.login(username, password) }

    context 'with valid credentials' do
      let(:username) { 'username_1' }
      let(:password) { 'password_1' }

      it do
        expect do
          is_expected.to eq(described_class.current_user)
        end.to change{ described_class.current_user }
      end
    end

    context 'with invalid credentials' do
      let(:username) { 'nobody_username' }
      let(:password) { 'password_1' }

      it do
        expect do
          is_expected.to be_nil
        end.to_not change{ described_class.current_user }
      end
    end
  end

  describe '.create' do
    include_context 'Loaded store'

    let(:new_username) { 'new_user' }
    let(:new_password) { 'password' }
    let(:new_role) { :regular }

    subject(:new_user) { described_class.create(new_username, new_password, new_role) }

    it do
      expect(Console::User.find_by(new_username)).to be_nil
      expect do
        expect(new_user.username).to eq(new_username)
        expect(Console::User.find_by(new_username)).not_to be_nil
      end.to change { Console::User.users.count }.by(1)
    end

    describe '.find_by' do
      include_context 'Loaded store'

      let(:user) { described_class.users.sample }

      subject(:target) { described_class.find_by(user.username) }

      it { is_expected.to be(user) }
    end

    describe '.login' do
      include_context 'Loaded store'

      before { described_class.users << target_user }

      let(:target_user) { described_class.new('target_user', target_password, :regular) }
      let(:target_password) { 'password' }

      subject(:logged_user) { described_class.login(target_user.username, target_password) }

      it do
        expect(Console::User.current_user).not_to be(target_user)
        expect do
          is_expected.to eq(target_user)
        end.to change { Console::User.current_user }
      end
    end

    describe '.destroy' do
      include_context 'Loaded store'

      before { described_class.users << target_user }

      let(:target_user) { described_class.new('target_user', 'password', :regular) }

      subject { described_class.destroy(target_user) }

      it do
        expect(Console::User.find_by(target_user.username)).not_to be_nil
        expect do
          is_expected.to eq(target_user)
          expect(Console::User.find_by(target_user.username)).to be_nil
        end.to change { Console::User.users.count }.by(-1)
      end
    end
  end
end
