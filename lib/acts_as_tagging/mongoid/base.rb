# encoding: utf-8
require 'acts_as_tagging/mongoid/tag'
require 'acts_as_tagging/mongoid/manager'

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

Mongoid::Document::ClassMethods.send(:include, ActsAsTagging::Base)