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

  context 'with loaded tree filesystem' do
    let(:root_item) { described_class.new('root') }
    let(:folder_A) { described_class.new('folder_level_1') }
    let(:folder_B) { described_class.new('folder_level_2') }
    let(:item_B) { described_class.new('item_level_2') }
    let(:folder_C) { described_class.new('folder_level_3') }

    before do
      root_item.add(folder_A).add(folder_B).add(folder_C)
      folder_B.add(item_B)
    end

    describe '#path' do
      it { expect(folder_C.path).to eq('root/folder_level_1/folder_level_2/folder_level_3') }
      it { expect(item_B.path).to eq('root/folder_level_1/folder_level_2/item_level_2') }
    end
  end
end
