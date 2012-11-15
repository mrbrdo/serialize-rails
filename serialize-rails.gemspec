$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "serialize-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "serialize-rails"
  s.version     = SerializeRails::VERSION
  s.authors     = ["Jan Berdajs"]
  s.email       = ["mrbrdo@gmail.com"]
  s.homepage    = "https://github.com/mrbrdo/serialize-rails"
  s.summary     = "Rails attribute serialization into yaml, json, xml and with ruby marshal."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">=3.0.0"
  s.add_dependency "ox"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'pry'
end
