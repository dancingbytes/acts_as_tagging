# encoding: utf-8
module ActsAsTagging

  class TagList < Array

    cattr_accessor :delimiter
    self.delimiter = ','

    def initialize(*args)
      add(*args)
    end # new

    def add(*names)

      concat(names)
      prepared
      self

    end # add

    def remove(*names)

      target = self.class.new(names)
      delete_if { |name| target.include?(name) }
      self

    end # remove

    def to_s
      join delimiter
    end # to_s

    alias_method :<<, :add

    private

    def prepared

      self.flatten!
      self.compact!
      self.map! { |a| a.split(delimiter) }
      self.flatten!
      self.map! { |a| a.strip.downcase }
      self.uniq!

    end # prepared

  end # TagList

end # ActsAsTagging