module Console
  class Folder < Filesystem
    def root?
      !parent
    end
  end
end
