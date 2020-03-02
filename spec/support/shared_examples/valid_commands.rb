RSpec.shared_examples 'Valid commands' do
  it { is_expected.to be_a(described_class) }
  it { is_expected.to be_valid }
  it { is_expected.to be_valid_arguments }
  it { is_expected.to be_valid_options }
end
