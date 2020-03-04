require 'spec_helper'

describe Console::Folder do
  describe '.new' do
    subject(:folder) { described_class.new('name') }

    it { is_expected.to be_folder }

    it { expect(subject.items).to be_empty }
    it { expect(subject.parent).to be_nil }
  end

  describe '#add' do
    include_context 'loaded tree'

    after { expect(subject.parent).to be(filesystem) }

    subject(:added_item) { filesystem.add(item) }

    context 'adding folder' do
      let(:item) { described_class.new('sub_folder') }

      it { is_expected.to be(item) }
    end

    context 'adding file' do
      let(:item) { Console::File.new('sub_file') }

      it { is_expected.to be(item) }
    end
  end

  context 'with' do
    include_context 'loaded tree'

    describe '#path' do
      it { expect(folder_level_3.path).to eq('/folder_level_1/folder_level_2/folder_level_3') }
      it { expect(item_1_level_2.path).to eq('/folder_level_1/folder_level_2/item_1_level_2') }
    end

    describe '#browse' do
      subject(:folder_target) { described_class.browse(directory, sought_path) }

      context 'when directory is root and receives back symbol' do
        let(:sought_path) { '..' }
        let(:directory) { filesystem }

        it { is_expected.to be(filesystem) }
      end

      context 'when directory is level 3 and receives back symbol' do
        let(:sought_path) { '..' }
        let(:directory) { folder_level_3 }

        it { is_expected.to be(folder_level_2) }
      end
    end

    describe '#seek' do
      subject(:folder_target) { described_class.seek(folder_level_1, array_path) }

      context 'when path directory exists' do
        let(:array_path) { %w[folder_level_2 folder_level_3 folder_level_4] }

        it { is_expected.to eq(folder_level_4) }
      end

      context 'when path directory no exists' do
        let(:array_path) { %w[folder_level_2 folder_level_3 folder_level_4 unknow_folder] }

        it { is_expected.to be_nil }
      end
    end
  end

  describe '.create' do
    include_context 'loaded tree'

    subject(:new_folder) { described_class.create(filesystem, folder_name) }

    context 'valid' do
      after { is_expected.to be_valid }

      let(:folder_name) { 'valid_folder_name' }

      it { expect(new_folder.parent).to eq(filesystem) }
    end
  end
end
