# encoding: utf-8
module ActsAsTagging

  class BaseManager

    class << self

      # Список тегов, ассоциированный с указанным классом или его экземпляром.
      def tags(*args)
        raise "ActsAsTagging::BaseManager. Class method `tags` must be rewrited!"
      end # tags  

      def find_ids_by_tags(*args)
        raise "ActsAsTagging::BaseManager. Class method `find_ids_by_tags` must be rewrited!"
      end # find_ids_by_tags  

      def related_tags_for(*args)
        raise "ActsAsTagging::BaseManager. Class method `find_related_tags_for` must be rewrited!"
      end # related_tags_for

      def tags_objects(*args)
        raise "ActsAsTagging::BaseManager. Class method `tags_objects` must be rewrited!"
      end # tags_objects

      def manage_tag_list(*args)
        raise "ActsAsTagging::BaseManager. Class method `manage_tag_list` must be rewrited!"
      end # manage_tag_list

    end # class << self  


    def initialize(context)
      
      @context = context
      init

    end # new

    private

    def init
      
      # Рабочий коллбек
      @context.set_callback(:save, :after) do |obj|

        block = ::ActsAsTagging::ContextStore[obj.class.to_s][:add]

        if block.is_a?(::Proc)

          obj.instance_variable_set(:@tags, 
            ::ActsAsTagging::TagList.new(
              obj.instance_variable_get(:@tags), block.call(obj)
            )
          )

        end # if

        # Обрабатываем теги
        ::ActsAsTagging::Manager.manage_tag_list(obj)

        # Сбрасываем информацию о тегах
        obj.instance_variable_set(:@tags, nil)
        nil

      end # set_callback

      @context.set_callback(:destroy, :after) do |obj|

        # Удаляе все теги, связанные с данным объектом
        ::ActsAsTagging::Manager.remove_tags_for(obj.class.to_s, obj.id)
        
        # Сбрасываем информацию о тегах
        obj.instance_variable_set(:@tags, nil)
        nil
        
      end # set_callback      

    end # init

  end # BaseManager

end # ActsAsTagging