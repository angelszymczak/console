require 'spec_helper'

describe Console::Store do
  let(:users) { %i[user_1 user_2 user_3]}
  let(:filesystem) { :filesystem }

  describe '.build' do
    context 'when persist file is not provided' do
      subject(:store) { described_class.build(users, filesystem) }

      it { expect(subject.persistible?).to be_falsey }
    end

    context 'when persist file is provided and not exists' do
      let(:filename) { 'testing_store_file' }

      subject(:store) { described_class.build(users, filesystem, filename) }

      it do
        expect(subject.persistible?).to be_truthy
        expect(File.exists?(Dir.pwd + '/db/' + filename)).to be_truthy
      end
    end
  end

  describe '.load' do
    context 'when persist file is provided and exists' do
      let(:filename) { 'testing_store_file' }

      before { described_class.build(users, filesystem, filename) }

      subject(:store) { described_class.load(filename) }

      it do
        expect(File.exists?(Dir.pwd + '/db/' + filename)).to be_truthy
        expect(subject.users).to contain_exactly(*users)
        expect(subject.filesystem).to eq(filesystem)
        expect(File.exists?(Dir.pwd + '/db/' + filename)).to be_truthy
      end
    end
  end
end
