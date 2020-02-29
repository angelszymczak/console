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
      context 'too big username' do
        let(:username) { 'large' * 100 }
        let(:password) { 'password' }

        subject(:user) { described_class.new(username, password, :super) }

        it do
          is_expected.not_to be_valid_profile
          expect(user.full_error_messages).to eq('Username size must be in [255..8] by [500].')
        end
      end

      context 'too short username' do
        let(:username) { 'short' }
        let(:password) { 'password' }

        subject(:user) { described_class.new(username, password, :super) }

        it do
          is_expected.not_to be_valid_profile
          expect(user.full_error_messages).to eq('Username size must be in [255..8] by [5].')
        end
      end

      context 'too short password' do
        let(:username) { 'username' }
        let(:password) { 'pass' }

        subject(:user) { described_class.new(username, password, :super) }

        it do
          is_expected.not_to be_valid_profile
          expect(user.full_error_messages).to eq('Password must have [8] characters.')
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
end
