# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pompeu/version'

Gem::Specification.new do |spec|
  spec.name          = "pompeu"
  spec.version       = Pompeu::VERSION
  spec.authors       = ["Mateu Yábar"]
  spec.email         = ["mateuyabar@equinox.one"]

  spec.summary       = %q{Helps to manage translations for apps}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/mateuyabar/pompeu"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "easy_translate"
  spec.add_dependency "google-cloud-translate"
  spec.add_dependency "highline"
  spec.add_dependency "nokogiri"
  spec.add_dependency "thor"
  spec.add_dependency "pycall"
end
