module ReadlineNG

  VERSION_MAJOR = 0
  VERSION_MINOR = 0
  VERSION_PATCH = 1
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"

  CONTROL_BS  = "\x08"
  CONTROL_INT = "\x03"
  CONTROL_LF  = "\x0a"
  CONTROL_CR  = "\x0d"

  KB_BS  = "\x7F"

  BLANK  = " "

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
          _print CONTROL_BS
        end
        _print string
        _puts CONTROL_CR
        _print @buf
      end
    end

    def tick
      t = STDIN.read_nonblock(128)
      process(t)

      raise Interrupt if @buf.include?(CONTROL_INT)

      a = @buf.split("\r")
      return if a.empty? && @buf.empty?
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

    private

    def process(c)
      case c
      when KB_BS
        @buf.chop!
        backspace
      else
        @buf += c
        _print c
      end
    end

    def backspace
      print CONTROL_BS,BLANK,CONTROL_BS
    end

    def _print(c)
      print c if visible
    end

    def _puts(c)
      puts c if visible
    end


  end
end

