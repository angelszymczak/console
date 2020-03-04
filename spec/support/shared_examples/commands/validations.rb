RSpec.shared_examples 'valid' do |string_input|
  context "for input [#{string_input}]" do
    let(:input) { string_input }

    it { is_expected.to be_a(described_class) }
    it { is_expected.to be_valid }
    it { is_expected.to be_valid_arguments }
    it { is_expected.to be_valid_options }
  end
end

RSpec.shared_examples 'invalid by arguments' do |string_input|
  context "for input [#{string_input}]" do
    before { is_expected.not_to be_valid }

    let(:input) { string_input }

    it { expect(subject.error_message).to match(/arguments/) }
  end
end

RSpec.shared_examples 'invalid by options' do |string_input|
  context "for input [#{string_input}]" do
    before { is_expected.not_to be_valid }

    let(:input) { string_input }

    it { expect(subject.error_message).to match(/options/) }
  end
end

RSpec.shared_examples 'invalid by exceptional arguments' do |string_input|
  context "for input [#{string_input}]" do
    before { is_expected.not_to be_valid }

    let(:input) { string_input }

    it { expect(subject.error_message).to match(/Cannot.*.directory/) }
  end
end

RSpec.shared_examples 'invalid by invalid namespace' do |string_input|
  context "for input [#{string_input}]" do
    before { is_expected.not_to be_valid }

    let(:input) { string_input }

    it { expect(subject.error_message).to match(/Namespace has been taken:/) }
  end
end

RSpec.shared_examples 'invalid by invalid path' do |string_input|
  context "for input [#{string_input}]" do
    before { is_expected.not_to be_valid }

    let(:input) { string_input }

    it { expect(subject.error_message).to match(/No such file or directory/) }
  end
end
