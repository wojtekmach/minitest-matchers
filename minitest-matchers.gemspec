# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "minitest/matchers/version"

Gem::Specification.new do |s|
  s.name        = "minitest-matchers"
  s.version     = Minitest::Matchers::VERSION
  s.authors     = ["Wojciech Mach", "Ryan Davis"]
  s.email       = ["wojtek@wojtekmach.pl", "ryand-ruby@zenspider.com"]
  s.homepage    = ""
  s.summary     = %q{Adds support for RSpec-style matchers}
  s.description = s.summary

  s.rubyforge_project = "minitest-matchers"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "minitest", "~> 5.0"

  s.add_development_dependency "rake"
end
