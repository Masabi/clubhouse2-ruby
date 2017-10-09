# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "clubhouse2"
  spec.version       = File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')
  spec.authors       = ["James Denness"]
  spec.email         = ["jd@masabi.com"]

  spec.summary       = %q{Clubhouse library for API version 2}
  spec.description   = %q{Does exactly what it says on the label}
  spec.homepage      = "https://www.masabi.com"
  spec.license       = "BSD"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.require_paths = [ 'lib' ]

  spec.add_dependency 'http', '~> 1'
  spec.add_dependency 'pry', '~> 0.10.4'

  spec.add_development_dependency "bundler", "~> 1.10"
end
