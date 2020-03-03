module Console
  class Folder < Filesystem
    def root?
      !parent
    end

    def folder?
      true
    end
  end
end
