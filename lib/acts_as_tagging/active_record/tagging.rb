# encoding: utf-8
module ActsAsTagging

  class Tagging < ::ActiveRecord::Base

    after_destroy :destroy_tag_if_unused
    after_save    :reload_tag_counter

    def with_transaction_returning_status
      yield
    end # with_transaction_returning_status

    def tag_counter
      self.class.where({ :tag_id => self.tag_id }).count
    end # tag_counter

    def destroy_tag_if_unused
      
      if self.tag_counter.zero? 
        ::ActsAsTagging::Tag.destroy_all(:id => self.tag_id)  
      else
        self.reload_tag_counter
      end  
      self

    end # destroy_tag_if_unused

    def reload_tag_counter
      
      ::ActsAsTagging::Tag.update_all({ 
        :counter => self.tag_counter 
      }, { 
        :id => self.tag_id 
      })
      self

    end # reload_tag_counter

    private

    def create_or_update(*args)

      begin
        super
      rescue ::ActiveRecord::RecordInvalid,
             ::ActiveRecord::RecordNotUnique
        false
      end

    end # create_or_update

  end # Tagging

end # ActsAsTagging