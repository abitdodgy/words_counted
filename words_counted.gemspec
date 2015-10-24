# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'words_counted/version'

Gem::Specification.new do |spec|
  spec.name          = "words_counted"
  spec.version       = WordsCounted::VERSION
  spec.authors       = ["Mohamad El-Husseini"]
  spec.email         = ["husseini.mel@gmail.com"]
  spec.description   = %q{A Ruby natural language processor to extract stats from text, such was word count and more.}
  spec.summary       = %q{See README.}
  spec.homepage      = "https://github.com/abitdodgy/words_counted"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
