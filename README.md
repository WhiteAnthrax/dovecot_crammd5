# DovecotCrammd5

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'dovecot_crammd5'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dovecot_crammd5

## Test

```
$ bundle
$ rspec -fd --color

DovecotCrammd5
  pattern normal
    returns cram-md5 hash when strings passed.
    returns cram-md5 hash when string and numbers passed.
    returns cram-md5 hash when upcase and downcase strings passed.
    returns cram-md5 hash when long strings(100) passed
    returns cram-md5 hash when none alphabetical charactors
  pattern abnormal
    case none String
      raise expection when nil passed.
      raise expection when Fixnum passed.
      raise expection when Array passed.
      raise expection when Hash passed.

Finished in 0.0139 seconds
9 examples, 0 failures

```

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
