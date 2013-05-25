# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'runoff/version'

Gem::Specification.new do |gem|
  gem.name          = "runoff"
  gem.version       = Runoff::VERSION
  gem.authors       = ["Aigars Dzerviniks"]
  gem.email         = ["dzerviniks.aigars@outlook.com"]
  gem.description   = %q{runoff provides functionality to export all the Skype chat history or only specified chats from the Skype SQLite database file to text files}
  gem.summary       = %q{Tool to export Skype chat history from the SQLite database to text files}
  gem.homepage      = 'https://github.com/aidzis/runoff'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'commander'
  gem.add_dependency 'sequel'
  gem.add_dependency 'rubyzip'
  gem.add_dependency 'sqlite3'
end
