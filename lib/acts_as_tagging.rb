# encoding: utf-8
require 'acts_as_tagging/version'

module ActsAsTagging

  MONGOID = defined?(Mongoid)
  AR      = defined?(ActiveRecord)

end # ActsAsTagging

require 'acts_as_tagging/tag_list'
require 'acts_as_tagging/builder'
require 'acts_as_tagging/methods'
require 'acts_as_tagging/context_store'
require 'acts_as_tagging/base_manager'

require 'acts_as_tagging/railtie'