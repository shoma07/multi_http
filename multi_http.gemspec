# frozen_string_literal: true

require_relative 'lib/multi_http/version'

Gem::Specification.new do |spec|
  spec.name          = 'multi_http'
  spec.version       = MultiHttp::VERSION
  spec.authors       = ['shoma07']
  spec.email         = ['23730734+shoma07@users.noreply.github.com']

  spec.summary       = 'multiple simultaneous HTTP requests'
  spec.description   = 'multiple simultaneous HTTP requests.'
  spec.homepage      = 'https://github.com/shoma07/multi_http'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi', '~> 1.15'
end
