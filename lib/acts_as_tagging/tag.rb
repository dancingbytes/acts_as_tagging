# encoding: utf-8
module ActsAsTagging

  class Tag
    include Mongoid::Document
    
    field :name
    field :owner_class
    field :owner_id
    field :system, :type => Boolean

    scope :usr_tags,   where(:system => false)
    scope :sys_tags,   where(:system => true)
    
    def owner
      self.owner_class.constantize.try(:find, self.owner_id)
    end # owner
    
    alias_method :context, :owner
    
  end # Tag

end # ActsAsTagging