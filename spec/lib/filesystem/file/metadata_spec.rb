require 'spec_helper'

describe Console::File::Metadata do
  describe '.new' do
    before { travel_to(time) }

    let(:author) { Console::User.new('OMG_it_s_me', 'password', :super) }
    let(:time) { Date.parse('01-03-2020').to_time }

    subject(:metadata) { described_class.new(author, type, time.to_i) }

    context 'valid' do
      let(:type) { 'valid_type' }
      before { is_expected.to be_valid }

      it { expect(subject.to_s).to eq("Author: [#{author}] - Date: 01-03-2020 - valid_type.") }
    end

    context 'invalid' do
      let(:type) { 'x' * 11 }

      before { is_expected.not_to be_valid }

      it { expect(subject.error_message).to match(/Type.*.exceed limit size/) }
    end
  end
end
