# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dovecot_crammd5/version'

Gem::Specification.new do |spec|
  spec.name          = "dovecot_crammd5"
  spec.version       = DovecotCrammd5::VERSION
  spec.authors       = ["KAWAHARA Masashi"]
  spec.email         = ["anthrax@unixuser.org"]
  spec.summary       = %q{generate dovecot's cram-md5 password hash}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
end
