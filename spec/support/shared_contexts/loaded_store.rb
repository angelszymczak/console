RSpec.shared_context 'loaded store' do
  let(:super_user) { Console::User.new('username_1', common_password, :super) }
  let(:regular_user) { Console::User.new('username_2', common_password, :regular) }
  let(:read_only_user) { Console::User.new('username_3', common_password, :read_only) }

  let(:common_password) { 'password' }

  let(:filesystem) { Console::Filesystem.initial_filesystem }

  let(:store) { Console::Store.new([super_user, regular_user, read_only_user], filesystem) }

  before do
    Console::User.store = store
    Console::User.current_user = super_user

    Console::Filesystem.store = store
    Console::Filesystem.pwd = filesystem
  end
end
