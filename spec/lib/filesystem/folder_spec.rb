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
    let(:root_item) { described_class.initial_filesystem('root') }
    let(:folder_level_1) { described_class.new('folder_level_1') }
    let(:folder_level_2) { described_class.new('folder_level_2') }
    let(:item_B) { described_class.new('item_level_2') }
    let(:folder_level_3) { described_class.new('folder_level_3') }

    before do
      root_item.add(folder_level_1).add(folder_level_2).add(folder_level_3)
      folder_level_2.add(item_B)
    end

    describe '#path' do
      it { expect(folder_level_3.path).to eq('root/folder_level_1/folder_level_2/folder_level_3') }
      it { expect(item_B.path).to eq('root/folder_level_1/folder_level_2/item_level_2') }
    end

    describe '#browse' do
      subject(:folder_target) { described_class.browse(directory, sought_path) }

      context 'when directory is root and receives back symbol' do
        let(:sought_path) { '..' }
        let(:directory) { root_item }

        it { is_expected.to be(root_item) }
      end

      context 'when directory is level 3 and receives back symbol' do
        let(:sought_path) { '..' }
        let(:directory) { folder_level_3 }

        it { is_expected.to be(folder_level_2) }
      end
    end
  end
end
