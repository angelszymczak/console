module Console
  class Folder < Filesystem
    PARENT_PATH = '..'

    def self.create(directory, name)
      new(name).tap do |folder|
        store.storing { directory.add(folder) } if folder.valid?
      end
    end

    def self.cd(directory, name)
      return if (folder = directory.find_folder_by(name)).nil?

      self.pwd = folder
    end

    # path [String]:
    #   - absolute path: '/absolute/path/to/target' starting with '/'
    #   - relative path: 'relative/path/to/target' starting with item's name.
    def self.directory_target_path(path)
      directory, relative_path =
        if absolute_path?(path)
          [root, path[1..].split(DIRECTORY_SEPARATOR)]
        else
          [pwd, path.split(DIRECTORY_SEPARATOR)]
        end

      [directory, relative_path.pop, relative_path]
    end

    def self.absolute_path?(path)
      path.start_with?(DIRECTORY_SEPARATOR)
    end

    # directory [Folder]
    # path [Array<String>]:
    #   i.e: ['path', 'to', 'my', 'target']
    #
    # Search folder inside of `directory`
    #
    # returns [Folder|nil]
    def self.seek(directory, path)
      loop do
        return if (directory = browse(directory, path.shift)).nil?
        return directory if path.empty?
      end
    end

    # sought_path [String]: folder's name
    # directory [Folder]
    #
    # returns [Folder|nil]
    def self.browse(directory, sought_folder_name)
      if parent_path?(sought_folder_name)
        directory.root? ? directory : directory.parent
      else
        directory.find_folder_by(sought_folder_name)
      end
    end

    def self.parent_path?(name)
      name == PARENT_PATH
    end

    attr_accessor :items

    def initialize(name, items = [])
      super(name)

      self.items = items
    end

    def root!
      self.root = self
    end

    def find_item_by(filename)
      items.find { |item| item.name == filename }
    end

    def find_folder_by(filename)
      folders.find { |folder| folder.name == filename }
    end

    def folder?
      true
    end

    def folders
      items.select(&:folder?)
    end

    def add(item)
      return if self.object_id == item.object_id

      item.parent = self
      (items << item).last
    end

    def remove(item)
      items.delete(item)
    end
  end
end
