# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_tagging/version"

Gem::Specification.new do |s|
  
  s.name = 'acts_as_tagging'
  s.version = ActsAsTagging::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['redfield', 'Tyralion']
  s.email = ['info@dancingbytes.ru']
  s.homepage = 'https://github.com/dancingbytes/acts_as_tagging'
  s.summary = 'Simple tags for rails'
  s.description = 'Simple tags for rails'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
  s.has_rdoc = false

  s.licenses = ['BSD']

  s.add_dependency 'railties', ['>= 3.0.0']
  
end