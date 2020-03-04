RSpec.shared_examples 'allow' do |string_input, roles|
  context "roles: [#{roles.map(&:to_s).join(' ')}]" do
    let(:input) { string_input }

    roles.each do |role|
      before { Console::User.current_user = Console::User.new("#{role}_user", 'password', role) }

      it { is_expected.to be_allow }
    end
  end
end

RSpec.shared_examples 'not allow' do |string_input, roles|
  context "roles: [#{roles.map(&:to_s).join(' ')}]" do
    let(:input) { string_input }

    roles.each do |role|
      before do
        Console::User.current_user =
          Console::User.new("#{role}_username", 'password', role)

        is_expected.not_to be_allow
      end

      it { expect(subject.error_message).to match(/There aren't enough permissions/) }
    end
  end
end
