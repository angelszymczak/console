module Console
  class Folder < Filesystem
    PARENT_PATH = '..'

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
