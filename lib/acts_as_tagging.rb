# encoding: utf-8
require 'acts_as_tagging/base'
require 'acts_as_tagging/document'
require 'acts_as_tagging/tag_list'
require 'acts_as_tagging/tag'

Mongoid::Document::ClassMethods.send(:include, ActsAsTagging::Base)