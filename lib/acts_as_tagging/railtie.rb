# encoding: utf-8
require 'rails'

module ActsAsTagging

  class Railtie < ::Rails::Railtie #:nodoc:
    
    initializer 'acts_as_tagging' do |app|
    
      if ::ActsAsTagging::MONGOID
        require 'acts_as_tagging/mongoid/base'
      elsif ::ActsAsTagging::AR
        require 'acts_as_tagging/active_record/base'
      end

    end # initializer

  end # Railtie

end # ActsAsTagging