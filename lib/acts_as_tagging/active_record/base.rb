# encoding: utf-8
require 'acts_as_tagging/active_record/tag'
require 'acts_as_tagging/active_record/tagging'
require 'acts_as_tagging/active_record/manager'

module ActsAsTagging
  
  module Base
    
    def acts_as_tagging(&block)

      include ::ActsAsTagging::InstanceMethods
      extend  ::ActsAsTagging::ClassMethods

      r = ::ActsAsTagging::Builder.new
      r.instance_eval &block if block_given?

      ::ActsAsTagging::ContextStore[self.to_s] = r.compile
      
      ::ActsAsTagging::Manager.new(self)
          
    end # acts_as_tagging
    
  end # Base
  
end # ActsAsTagging

ActiveRecord::Base.send(:extend, ActsAsTagging::Base)