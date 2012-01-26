# encoding: utf-8
module ActsAsTagging

  class Tagging < ::ActiveRecord::Base

#    belongs_to  :tag,     :class_name => 'ActsAsTagging::Tag'
#    belongs_to  :context, :polymorphic => true

    scope :uniq, group("`taggings`.`context_type`, `taggings`.`context_id`")

    after_destroy :destroy_tag_if_unused
    after_save    :reload_tag_counter

    def with_transaction_returning_status
      yield
    end # with_transaction_returning_status

    def tag_counter
      self.class.uniq.where({ :tag_id => self.tag_id })
    end # tag_counter

    def destroy_tag_if_unused
      
      self.tag_counter.length.zero? ? self.tag.destroy : self.reload_tag_counter
      self

    end # destroy_tag_if_unused

    def reload_tag_counter
      
      ::ActsAsTagging::Tag.update_all({ :counter => self.tag_counter.length }, { :id => self.tag_id })
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