require 'spec_helper'

describe Console::Folder do
  describe '.new' do
    subject(:folder) { described_class.new('name') }

    it { is_expected.to be_folder }

    it { expect(subject.items).to be_empty }
    it { expect(subject.parent).to be_nil }
  end

  describe '#add' do
    let(:root_item) { described_class.new('root') }

    after { expect(subject.parent).to be(root_item) }

    subject(:added_item) { root_item.add(item) }

    context 'adding folder' do
      let(:item) { described_class.new('sub_folder') }

      it { is_expected.to be(item) }
    end

    context 'adding file' do
      let(:item) { Console::File.new('sub_file') }

      it { is_expected.to be(item) }
    end
  end
end
