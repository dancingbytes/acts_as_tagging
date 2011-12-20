# encoding: utf-8
module ActsAsTagging
  
  module Document
    
    module ClassMethods

      def tags
        
        ActsAsTagging::Tag.where(:owner_class => self.name).distinct(:name)
        
      end # tags

      def find_by_tags(list)
        
        tag_names = ActsAsTagging::TagList.new(list)
        ids = ActsAsTagging::Tag.where(:name.in => tag_names, :owner_class => self.name).distinct(:owner_id)
        self.where(:_id.in => ids)

      end # find_by_tags

      def find_related_tags_for(list)
        
        tag_names = ActsAsTagging::TagList.new(list)
        ids = ActsAsTagging::Tag.where(:name.in => tag_names, :owner_class => self.name).distinct(:owner_id)
        ActsAsTagging::Tag.where(:owner_id.in => ids).distinct(:name)

      end # find_related_tags_for

    end # ClassMethods

    module InstanceMethods
      
      def tags
        ActsAsTagging::Tag.where(:owner_class => self.class.name, :owner_id => self.id)
        
      end

      # Список тегов. Выборка производится следующим образом:
      # вначале пытаемся выбрать данные из переменной @tag_list, если данных нет то,
      # выбираем из базы. Результат выборки кешируется в @tag_list и при послудеющих
      # запросах, данные берутся из @tag_list.
      def tag_list(reload = false)

        @tag_list = nil if reload
        # Выбираем теги из пользовательского списка (если есть) или из базы данных
        @tag_list ||= ActsAsTagging::TagList.new( @tag_list || self.tags.usr_tags.asc(:name).distinct(:name) )

      end # tag_list

      def tag_list=(*args)
        @tag_list = args
      end # tag_list

      def tag_sys_list=(*args)
        @tag_sys_list = args
      end # tag_sys_list

      def tag_sys_list(reload = false)
        
        @tag_sys_list = nil if reload
        # Выбираем теги из системного списка (если есть) или из базы данных
        @tag_sys_list ||= ActsAsTagging::TagList.new( @tag_sys_list || self.tags.sys_tags.asc(:name).distinct(:name))
        
      end # tag_sys_list

      private

      def tagging_if(c)
        opts = self.class.read_inheritable_attribute :act_as_tagging_options
        lmb = opts[:if] if opts && opts[:if].respond_to?(:call)
        lmb ||= ->(c) { true }
        lmb.call(c) && true
        
      end # tagging_if

      # Сохраняем/удаляем теги после сохранения объекта.
      def aat_manage_tags
        return unless tagging_if(self)

        # Обрабатываем пользовательские теги (если заданы)
        aat_manage_tag_list(
          # Теги поьзовательского типа из базы даных.
          ActsAsTagging::TagList.new( self.tags.usr_tags.distinct(:name) ),
          # Теги пользовательского типа из usr_tags.
          ActsAsTagging::TagList.new(@tag_list),
          # Статус нового тега
          0
        ) unless @tag_list.nil?

        # Обрабатываем системные теги (если заданы)
        aat_manage_tag_list(
          # Теги системного типа из базы даных.
          ActsAsTagging::TagList.new( self.tags.sys_tags.distinct(:name) ),
          # Теги системного типа из sys_tags.
          ActsAsTagging::TagList.new(@tag_sys_list),
          # Статус нового тега
          1
        ) unless @tag_sys_list.nil?
        @tag_sys_list = nil
        @tag_list = nil

      end # aat_manage_tags

      def aat_manage_tag_list(old_list, new_list, system = false)

        # Удаляем из базы "устаревшие" теги -- теги,
        # отсуствующие в пользовательском списке
        unless (diff = (old_list - new_list)).empty?
          ActsAsTagging::Tag.where(:name.in => diff, :owner_id => self.id, :system => system).destroy_all
        end # unless

        # Добавляем теги, введенные пользователем и отсутствующие в базе.
        (new_list - old_list).each do |name|
          ActsAsTagging::Tag.find_or_create_by(
            :name => name, 
            :owner_class => self.class.name,
            :owner_id => self.id,
            :system => system
          )
        end # each

      end # aat_manage_tag_list

    end # InstanceMethods
    
  end # Document
  
end # ActsAsTagging
