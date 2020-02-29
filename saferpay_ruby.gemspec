lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "saferpay_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "saferpay_ruby"
  spec.version       = SaferpayRuby::VERSION
  spec.authors       = ["nischay"]
  spec.email         = ["nischay.dhiman@gmail.com"]

  spec.summary       = "Saferpay JSON application programming interface with a ruby API wrapper built with Net::HTTP "
  spec.description   = "
  Saferpay JSON application programming interface with a ruby API wrapper built with Net::HTTP

  Saferpay API is designed to have predictable, resource-oriented URLs and to use HTTP response codes to indicate API errors. Saferpay use built-in HTTP features, like HTTP authentication and HTTP verbs, which can be understood by off-the-shelf HTTP clients. JSON will be returned in all responses from the API, including errors."
  spec.homepage      = "https://github.com/nischay-dhiman/saferpay_ruby"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://github.com/nischay-dhiman/saferpay_ruby"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nischay-dhiman/saferpay_ruby"
  spec.metadata["changelog_uri"] = "https://github.com/nischay-dhiman/saferpay_ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
