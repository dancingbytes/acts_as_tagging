# encoding: utf-8
module ActsAsTagging

  class Manager < ::ActsAsTagging::BaseManager

    class << self

      def tags(context_type = nil, context_id = nil)

        ::ActsAsTagging::TagList.new(
          self.tags_objects(context_type, context_id).distinct(:name)
        )  

      end # tags
      
      def find_ids_by_tags(context_type, tags_list = [])
      
        return [] if tags_list.empty?

        req = ::ActsAsTagging::Tag.
          where({
            :name.in => tags_list,
            :context_type => context_type
          })

        req.distinct(:context_id)

      end # find_ids_by_tags

      def related_tags_for(context_type, tags_list = [])
        
        return self.tags(context_type) if tags_list.empty?

        ids = self.find_ids_by_tags(context_type, tags_list)
        return [] if ids.empty?

        req = ::ActsAsTagging::Tag.
          where({ 
            :context_type   => context_type,
            :context_id.in  => ids
          })
        
        req.distinct(:name)

      end # related_tags_for

      def tags_objects(context_type = nil, context_id = nil)

        req = ::ActsAsTagging::Tag

        req = req.where(:context_type => context_type)  if context_type
        req = req.where(:context_id => context_id)      if context_id

        req
        
      end # tags_objects

      def manage_tag_list(obj)
        
        # Теги в базе
        db_tags   = ::ActsAsTagging::Manager.tags(obj.class.to_s, obj.id)

        # Новые теги
        new_tags  = obj.tags

        # Удаляем из базы "устаревшие" теги -- теги,
        # отсуствующие в массиве new_tags
        unless (diff = (db_tags - new_tags)).empty?

          ::ActsAsTagging::Tag.
            where({
              :name.in => diff, 
              :context_type => obj.class.to_s,
              :context_id => obj.id 
            }).
            destroy_all

        end # unless

        # Добавляем новые теги
        (new_tags - db_tags).each do |tag_name|

          ::ActsAsTagging::Tag.find_or_create_by({
            :context_type => obj.class.to_s,
            :context_id   => obj.id,
            :name => tag_name
          })

        end # each

      end # manage_tag_list

    end # class << self
    
  end # Manager

end # ActsAsTagging