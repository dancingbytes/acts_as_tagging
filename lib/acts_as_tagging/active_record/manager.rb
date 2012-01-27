# encoding: utf-8
module ActsAsTagging

  class Manager < ::ActsAsTagging::BaseManager

    class << self

      def tags(context_type = nil, context_id = nil)

        ::ActsAsTagging::TagList.new(
          self.tags_objects(context_type, context_id).map(&:name)
        )

      end # tags

      def by_tags(klass, tags_list = [])

        join = ""
        tags_list.each_with_index do |tag, index|

          taggings_alias, tags_alias = "taggings_#{index}", "tags_#{index}"

          join << <<-END
            INNER JOIN #{::ActsAsTagging::Tagging.quoted_table_name} #{taggings_alias} ON
            #{taggings_alias}.context_id = #{klass.quoted_table_name}.#{klass.primary_key} AND
            #{taggings_alias}.context_type = '#{klass.to_s}'

            INNER JOIN #{::ActsAsTagging::Tag.quoted_table_name} #{tags_alias} ON
            #{taggings_alias}.tag_id = #{tags_alias}.id AND
            #{tags_alias}.name = '#{tag}'
          END

        end # each_with_index
        
        klass.joins( join )

      end # by_tags  

      def related_tags_for(context_type, tags_list = [])

        return self.tags(context_type) if tags_list.empty?

        ids = self.find_ids_by_tags(context_type, tags_list)
        return [] if ids.empty?

        join = <<-END
          INNER JOIN #{::ActsAsTagging::Tagging.quoted_table_name} ON
          #{::ActsAsTagging::Tagging.quoted_table_name}.tag_id = tags.id AND
          #{::ActsAsTagging::Tagging.quoted_table_name}.context_type = '#{context_type}' AND
          #{::ActsAsTagging::Tagging.quoted_table_name}.context_id IN (#{ids.join(',')})
        END

        tags_list.map! { |n| "'#{n}'" }

        req = ::ActsAsTagging::Tag.
          select(
            "DISTINCT #{::ActsAsTagging::Tag.quoted_table_name}.name"
          ).
          joins( join ).
          order(
            "#{::ActsAsTagging::Tag.quoted_table_name}.name"
          ).
          having(
            "#{::ActsAsTagging::Tag.quoted_table_name}.name NOT IN (#{tags_list.join(',')})"
          )

        req.map(&:name)  

      end # related_tags_for  

      def tags_objects(context_type = nil, context_id = nil)

        req = ::ActsAsTagging::Tag.
          select(
            "DISTINCT #{::ActsAsTagging::Tag.quoted_table_name}.*"
          ).
          joins(
            "INNER JOIN #{::ActsAsTagging::Tagging.quoted_table_name} ON " << 
            "#{::ActsAsTagging::Tagging.quoted_table_name}.tag_id = #{::ActsAsTagging::Tag.quoted_table_name}.id"
          )
          
        req = req.where({ :taggings => { :context_type => context_type } }) if context_type
        req = req.where({ :taggings => { :context_id => context_id } })     if context_id
        req

      end #  

      def manage_tag_list(obj)

        # Теги в базе
        db_tags   = ::ActsAsTagging::Manager.tags(obj.class.to_s, obj.id)

        # Новые теги
        new_tags  = obj.tags

        # Удаляем из базы "устаревшие" теги -- теги,
        # отсуствующие в массиве new_tags
        unless (diff = (db_tags - new_tags)).empty?

          ::ActsAsTagging::Tag.
            where({ :taggings => { :context_type => obj.class.to_s } }).
            where({ :taggings => { :context_id => obj.id } }).
            where({ :tags => { :name => diff } }).
            joins(
              "INNER JOIN #{::ActsAsTagging::Tagging.quoted_table_name} ON " << 
              "#{::ActsAsTagging::Tagging.quoted_table_name}.tag_id = #{::ActsAsTagging::Tag.quoted_table_name}.id"
            ).
            destroy_all

        end # unless

        # Добавляем новые теги
        (new_tags - db_tags).each do |tag_name|

          ::ActsAsTagging::Tagging.create({
            :context_type => obj.class.to_s,
            :context_id   => obj.id,
            :tag_id => ::ActsAsTagging::Tag.find_or_create({ :name => tag_name }).id
          })

        end # each

      end # manage_tag_list

    end # class << self

  end # Manager

end # ActsAsTagging  