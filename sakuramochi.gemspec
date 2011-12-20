# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sakuramochi/version"

Gem::Specification.new do |s|
  s.name        = "sakuramochi"
  s.version     = Sakuramochi::VERSION
  s.authors     = ["mashiro"]
  s.email       = ["mail@mashiro.org"]
  s.homepage    = "https://github.com/mashiro/sakuramochi"
  s.summary     = %q{Minimal extensions for ActiveRecord 3}
  s.description = %q{Predicates and conditions that extends to the ActiveRecord 3}

  s.rubyforge_project = "sakuramochi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", "~> 3.0"
  s.add_dependency "activerecord", "~> 3.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
end
