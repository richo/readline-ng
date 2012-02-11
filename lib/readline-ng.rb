module ReadlineNG

  VERSION_MAJOR = 0
  VERSION_MINOR = 0
  VERSION_PATCH = 1
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"

  CONTROL_BS  = "\x08"
  CONTROL_INT = "\x03"
  CONTROL_LF  = "\x0a"
  CONTROL_CR  = "\x0d"

  class Reader

    # TODO Arrange for the terminal to be in raw mode etc.
    # XXX This probably needs to be a singleton, having more than one doesn't
    # make a whole lot of sense, although potentially giving out rope is not a
    # terrible idea here

    attr_accessor :lines, :visible

    def initialize
      @buf = ""
      @visible = true
      @lines = []
    end

    def puts_above(string)
      if visible
        @buf.length.times do
          # Backspace to beginning of line
          print CONTROL_BS
        end
        print string
        puts CONTROL_CR
        print @buf
      end
    end

    def print_char(c)
      case c
      when "\x7F"
        print CONTROL_BS
      else
        print c
      end
    end

    def tick
      t = STDIN.read_nonblock(128)
      print_char(t) if @visible
      @buf += t

      raise Interrupt if @buf.include?(CONTROL_INT)

      a = @buf.split("\r")
      @buf = @buf[-1] == "\r" ? "" : a.pop

      @lines += a
    rescue Errno::EAGAIN
      nil
    end

    def line
      @lines.shift
    end

    def each_line
      yield @lines.shift while @lines.any?
    end

  end
end

