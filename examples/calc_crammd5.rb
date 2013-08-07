#!/bin/env ruby

require 'dovecot_crammd5'

secret = ARGV[0]
str = DovecotCrammd5.calc(secret)
print "{CRAM-MD5}#{str}\n"
