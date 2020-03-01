require 'spec_helper'

describe Console::Prompt do
  before do
    ENV['COMPANY_NAME'] = 'Testing Company'
    ENV['APP_KEY'] = 'testing-key'

    allow(STDOUT).to receive(:puts) { nil }
    allow(Kernel).to receive(:print).with(/Please enter/)
  end

  describe 'setup block' do
    describe 'app login block' do
      before { allow(STDIN).to receive(:noecho).and_return('bad-key', 'testing-key') }

      it 'looping to enter correct key' do
        expect(STDOUT).to receive(:puts)
          .with(/Please enter #{ENV['COMPANY_NAME']} App Key:/)
          .twice
        expect(STDIN).to receive(:noecho).exactly(:twice)

        expect(STDOUT).to receive(:puts).with(/Invalid Key App/).once
        expect(STDOUT).to receive(:puts).with(/App logged/).once

        described_class.send(:app_login)
      end
    end
  end
end
