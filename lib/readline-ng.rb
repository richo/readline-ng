module ReadlineNG

  VERSION_MAJOR = 0
  VERSION_MINOR = 0
  VERSION_PATCH = 3
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"

  CONTROL_BS  = "\x08"
  CONTROL_INT = "\x03"
  CONTROL_LF  = "\x0a"
  CONTROL_CR  = "\x0d"

  KB_BS  = "\x7F"
  KB_CR  = "\x0d"

  BLANK  = " "

  class Reader

    @@initialized = false

    # XXX This probably needs to be a singleton, having more than one doesn't
    # make a whole lot of sense, although potentially giving out rope is not a
    # terrible idea here

    attr_accessor :lines, :visible

    # A third party dev can overload filter to implement their own actions
    def filter
    end

    def initialize(visible=true)
      @buf = ""
      @visible = visible
      @lines = []
      if @@initialized
        STDERR.puts "A ReadlineNG reader is already instanciated, expect weirdness"
      else
        @@initialized = true
      end

      stty_saved = `stty -g`
      `stty -echo raw`
      at_exit do
        `stty #{stty_saved}`
      end
    end

    def puts_above(string)
      if visible
        backspace(@buf.length)
        _print string.gsub("\n", "\n\r")
        _puts CONTROL_CR
        _print @buf
      end
    end

    def tick
      return if @locked
      t = STDIN.read_nonblock(128)
      process(t)
      filter # Expect a 3rd party dev to override this

      raise Interrupt if @buf.include?(CONTROL_INT)

      a = @buf.split("\r")
      return if a.empty? && @buf.empty?
      @buf = @buf[-1] == "\r" ? "" : a.pop

      @lines += a
    rescue Errno::EAGAIN
      nil
    end

    def line
      @locked = true
      @lines.shift.tap do
        @locked = false
      end
    end

    def each_line
      yield @lines.shift while @lines.any?
    end

    def get_line
      # Blocks!
      tick until lines.any?
      line
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

    def backspace(n=1)
      print CONTROL_BS*n,BLANK*n,CONTROL_BS*n
    end

    def _print(c)
      print c if visible
    end

    def _puts(c)
      puts c if visible
    end


  end
end

