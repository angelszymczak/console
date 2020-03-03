require 'spec_helper'

describe Console::File::Metadata do
  describe '.new' do
    before { travel_to(time) }

    let(:author) { Console::User.new('OMG_it_s_me', 'password', :super) }
    let(:time) { Date.parse('01-03-2020').to_time }

    subject(:metadata) { described_class.new(author, time.to_i) }

    it { expect(subject.to_s).to eq("Author: [#{author}] - Date: 01-03-2020") }
  end
end
