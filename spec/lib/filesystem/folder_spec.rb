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

  context '#path' do
    let(:root_item) { described_class.new('root') }
    let(:item_1) { described_class.new('level_1') }
    let(:item_2) { described_class.new('level_2') }
    let(:item_3) { described_class.new('level_3') }

    subject(:path) { root_item.add(item_1).add(item_2).add(item_3).path }

    it { is_expected.to eq('root/level_1/level_2/level_3') }
  end
end
