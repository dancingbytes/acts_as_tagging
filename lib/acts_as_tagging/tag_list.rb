# encoding: utf-8
module ActsAsTagging

  class TagList < Array

    cattr_accessor :delimiter
    self.delimiter = ','

    def initialize(*args)
      add(*args)
    end # new

    def add(*names)

      prepared(names)
      concat(names)
      self

    end # add

    def remove(*names)

      prepared(names)
      delete_if { |name| names.include?(name) }
      self

    end # remove

    def to_s
      join delimiter
    end # to_s

    alias_method :<<, :add

    private

    def prepared(args)

      args.flatten!
      args.compact!
      args.map! { |a| a.split(delimiter) }
      args.flatten!
      args.map! { |a| a.strip.downcase }
      args.uniq!

    end # prepared

  end # TagList

end # ActsAsTagging