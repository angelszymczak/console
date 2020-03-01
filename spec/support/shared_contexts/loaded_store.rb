RSpec.shared_context 'Loaded store' do
  let(:super_user) { Console::User.new('username_1', super_user_password, :super) }
  let(:super_user_password) { 'password_1' }

  let(:regular_user) { Console::User.new('username_2', regular_user_password, :regular) }
  let(:regular_user_password) { 'password_2' }

  let(:read_only_user) { Console::User.new('username_3', read_only_user_password, :read_only) }
  let(:read_only_user_password) { 'password_3' }

  let(:filesystem) { instance_double(Console::Folder, name: '/') }

  let(:store) { Console::Store.new([super_user, regular_user, read_only_user], filesystem) }

  before do
    Console::User.store = store
    Console::User.current_user = super_user

    Console::Filesystem.store = store
    Console::Filesystem.pwd = filesystem
  end
end
