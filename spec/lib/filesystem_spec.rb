require 'spec_helper'

describe Console::Filesystem do
  describe '.initial_filesystem' do
    subject(:directory) { described_class.initial_filesystem }

    it { is_expected.to be_root }
    it { expect(subject.name).to eq('/') }
    it { expect(subject.parent).to be_nil }
  end

  describe '.new' do
    subject(:item) { described_class.new(name) }

    context 'valid' do
      let(:name) { 'valid_name-1' }

      it { is_expected.to be_valid }
    end

    context 'invalid' do
      after { is_expected.not_to be_valid }

      context 'by name format' do
        let(:name) { '!invalid#name$' }

        before { is_expected.not_to be_valid_name_format }

        it { expect(subject.error_message).to match(/Name.*.invalid format/) }
      end

      context 'by name size' do
        let(:name) { 'a' * 256 }

        before { is_expected.not_to be_valid_name_size }

        it { expect(subject.error_message).to match(/Name.*.exceed limit size/) }
      end
    end
  end
end
