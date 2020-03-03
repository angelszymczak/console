module Console
  class Folder < Filesystem

    attr_accessor :items

    def initialize(name, items = [], parent = nil)
      super(name, parent)

      self.items = items
    end

    def root?
      !parent
    end

    def folder?
      true
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
