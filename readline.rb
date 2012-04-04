#!/usr/bin/env ruby

$:.push File.expand_path("../lib", __FILE__)
require 'readline-ng'

reader = ReadlineNG::Reader.new

loop do
  line = reader.get_line
  reader.puts_above("Got #{line}")
end
