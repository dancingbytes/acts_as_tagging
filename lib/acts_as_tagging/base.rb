# encoding: utf-8
module ActsAsTagging

  module Base
    
    def acts_as_tagging(options = {})

      include ActsAsTagging::Document::InstanceMethods
      extend  ActsAsTagging::Document::ClassMethods
      
      class_attribute :act_as_tagging_options
      write_inheritable_attribute :act_as_tagging_options, options

      after_save  :aat_manage_tags
        
    end # act_as_tagging

  end # Base

end # ActsAsTagging