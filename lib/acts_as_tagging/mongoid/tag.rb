# encoding: utf-8
module ActsAsTagging

  class Tag
    
    include Mongoid::Document
    
    field :name
    field :context_type
    field :context_id
    
    # For mongoid 2.4
    unless (::Mongoid::VERSION =~ /\A2.4/).nil?

      index(
        [
          [ :name,          Mongo::ASCENDING ],
          [ :context_type,  Mongo::ASCENDING ],
          [ :context_id,    Mongo::ASCENDING ]
        ],
        unique: true
      )

    else

      # For mongoid 3

      index({
        
        name: 1,
        context_type: 1,
        context_id:   1

      }, {  
        unique: true
      })
    
    end  

  end # Tag

end # ActsAsTagging