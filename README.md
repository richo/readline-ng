## Readline ng

[![Build Status](https://secure.travis-ci.org/richoH/readline-ng.png?branch=master)](http://travis-ci.org/richoH/readline-ng)

Readline-NG is /not/ a drop in replacement for readline.

It addresses a very specific need I had inside a twitter client, but
hopefully it's of use to someone else, too.

Readline relies on being able to poll for input often, leading to a
hideously inefficient event loop, but generally
```ruby
reader = ReadlineNG::Reader.new
loop do
  reader.tick
  reader.each_line do |line|
    # Handle full line of input
    reader.puts_above("user input #{line}")
  end
end
```
