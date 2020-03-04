RSpec.shared_context 'loaded tree' do
  let(:super_user) { Console::User.new('username_1', common_password, :super) }
  let(:regular_user) { Console::User.new('username_2', common_password, :regular) }
  let(:read_only_user) { Console::User.new('username_3', common_password, :read_only) }
  let(:common_password) { 'password' }

  let(:filesystem) { Console::Folder.initial_filesystem('/') }
  let(:folder_level_1) { Console::Folder.new('folder_level_1') }
  let(:folder_level_2) { Console::Folder.new('folder_level_2') }
  let(:item_1_level_2) { Console::Folder.new('item_1_level_2') }
  let(:folder_level_3) { Console::Folder.new('folder_level_3') }
  let(:folder_level_4) { Console::Folder.new('folder_level_4') }
  let(:store) { Console::Store.new([super_user, regular_user, read_only_user], filesystem) }

  before do
    filesystem
      .add(folder_level_1)
      .add(folder_level_2)
      .add(folder_level_3)
      .add(folder_level_4)

    folder_level_2.add(item_1_level_2)

    Console::User.store = store
    Console::User.current_user = super_user

    Console::Filesystem.store = store
    Console::Filesystem.pwd = filesystem
  end
end
