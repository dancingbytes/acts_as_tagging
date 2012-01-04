# encoding: utf-8
module ActsAsTagging

  class Tag
    include Mongoid::Document
    
    field :name
    field :owner_class
    field :owner_id
    field :system, :type => Boolean

#    index :name, background => true,  unique: true
#    index :owner_class, :background => true
#    index :owner_id,    :background => true
#    index :system,      :background => true

    index(
      [
        [ :name,        Mongo::ASCENDING ],
        [ :owner_class, Mongo::ASCENDING ],
        [ :owner_id,    Mongo::ASCENDING ],
        [ :system,      Mongo::ASCENDING ]
      ],
      unique: true
    )

    scope :usr_tags,   where(:system => false)
    scope :sys_tags,   where(:system => true)
    
    def owner
      self.owner_class.constantize.try(:find, self.owner_id)
    end # owner
    
    alias_method :context, :owner
    
  end # Tag

end # ActsAsTagging