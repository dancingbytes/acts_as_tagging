# encoding: utf-8
module ActsAsTagging

  module ClassMethods

    def tags
      ::ActsAsTagging::Manager.tags(self.to_s)
    end # tags

    def find_ids_by_tags(*args)
      ::ActsAsTagging::Manager.find_ids_by_tags(self.to_s, ::ActsAsTagging::TagList.new(args) )
    end # find_ids_by_tags

    def related_tags_for(*args)
      ::ActsAsTagging::Manager.related_tags_for(self.to_s, ::ActsAsTagging::TagList.new(args) )
    end # related_tags_for

    def tags_objects
      ::ActsAsTagging::Manager.tags_objects(self.to_s)
    end # tags_objects

  end # ClassMethods  


  module InstanceMethods

    def tags_objects
      ::ActsAsTagging::Manager.tags_objects(self.class.to_s, self.id)
    end # tags_objects

    def tags(reload = false)

      instance_variable_set(:@tags, nil) if reload

      if (tags_list = instance_variable_get(:@tags)).nil? 

        tags_list = ::ActsAsTagging::Manager.tags(self.class.to_s, self.id)
        tags_list << instance_variable_get(:@tags)
        instance_variable_set(:@tags, tags_list)

      end # if

      tags_list

    end # tags

    def tags=(*args)
      instance_variable_set(:@tags, ::ActsAsTagging::TagList.new(args))
    end # tags=

  end # InstanceMethods  

end # ActsAsTagging  