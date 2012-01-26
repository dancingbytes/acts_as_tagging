# encoding: utf-8
module ActsAsTagging

  class Tag
    
    include Mongoid::Document
    
    field :name
    field :context_type
    field :context_id
    
    index(
      [
        [ :name,          Mongo::ASCENDING ],
        [ :context_type,  Mongo::ASCENDING ],
        [ :context_id,    Mongo::ASCENDING ]
      ],
      unique: true
    )

  end # Tag

end # ActsAsTagging