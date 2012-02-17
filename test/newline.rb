#!/usr/bin/env ruby
require './lib/readline-ng'

puts "Should output"
puts "line1\nline2"
puts ""

reader = ReadlineNG::Reader.new

reader.puts_above("line1\nline2")

