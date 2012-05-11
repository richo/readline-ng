# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "readline-ng"

Gem::Specification.new do |s|
  s.name        = "readline-ng"
  s.version     = ReadlineNG::VERSION
  s.authors     = ["Rich Healey"]
  s.email       = ["richo@psych0tik.net"]
  s.homepage    = "http://github.com/richo/readline-ng"
  s.summary     = "Essentially, readline++"
  s.description = s.summary

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
