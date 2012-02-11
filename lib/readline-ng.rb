module ReadlineNG

  VERSION_MAJOR = 0
  VERSION_MINOR = 0
  VERSION_PATCH = 1
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"

  class Reader

    # TODO Arrange for the terminal to be in raw mode etc.
    #
    attr_accessor :lines, :visible

    def initialize
      @buf = ""
      @visible = true
      @lines = []
    end

    def print_char(c)
      case c
      when "\x7F"
        print "\x0b"
      else
        print c
      end
    end

    def tick
      t = STDIN.read_nonblock(128)
      print_char(t) if @visible
      @buf += t

      raise Interrupt if @buf.include?("\x03")

      a = @buf.split("\r")
      @buf = @buf[-1] == "\r" ? "" : a.pop

      @lines += a
    rescue Errno::EGAIN
      nil
    end

  end
end

