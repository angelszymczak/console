require 'spec_helper'

describe Console::File do
  describe '.new' do
    include_context 'loaded tree'

    subject(:file) { described_class.new('name', content) }

    context 'valid' do
      let(:content) { 'I\'m a valid content' }

      it { is_expected.to be_valid }
      it { is_expected.to be_file }
    end

    context 'invalid' do
      after { is_expected.not_to be_valid }

      context 'by content size' do
        let(:content) { 'a' * 1_000_001 }

        before { is_expected.not_to be_valid_content_size }

        it { expect(subject.error_message).to match(/Content.*.exceed limit size/) }
      end
    end
  end
end
