module ReadlineNG

  VERSION_MAJOR = 0
  VERSION_MINOR = 0
  VERSION_PATCH = 6
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"

  CONTROL_BS  = "\x08"
  CONTROL_INT = "\x03"
  CONTROL_LF  = "\x0a"
  CONTROL_CR  = "\x0d"

  KB_BS  = "\x7F"
  KB_CR  = "\x0d"

  KB_LEFT  = "\x25"
  KB_RIGHT = "\x27"

  BLANK  = " "

  class Reader

    @@initialized = false

    # XXX This probably needs to be a singleton, having more than one doesn't
    # make a whole lot of sense, although potentially giving out rope is not a
    # terrible idea here

    attr_accessor :lines, :visible, :polling_resolution

    # A third party dev can overload filter to implement their own actions
    def filter
    end

    def initialize(visible=true, opts = {})
      @buf = ""
      @index = 0
      @visible = visible
      @lines = []
      @polling_resolution = opts[:polling_resolution] || 20
      if @@initialized
        STDERR.puts "A ReadlineNG reader is already instanciated, expect weirdness"
      else
        @@initialized = true
      end

      setup
      at_exit do
        teardown
      end
    end

    def wait(n)
      (n * polling_resolution).times do
        tick
        sleep 1.0/polling_resolution
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
      t = STDIN.read_nonblock(128)
      t.each_char { |c| process(c) }
      filter # Expect a 3rd party dev to override this
    rescue Errno::EAGAIN
      nil
    end

    def line
      @lines.shift
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
      # TODO This method is getting monolithic, think about how to modularise it
      case c
      when "\r"
        @lines += [@buf]
        reset
      when CONTROL_INT
        raise Interrupt
      when KB_BS
        if @buf.chop!
          @index -= 1
          backspace
        end
      when KB_LEFT
        if @buf and @index != 0
          @index -= 1
        end
      when KB_RIGHT
        if @buf and @index < @buf.length
          @index -= 1
        end
      else
        @buf = @buf.insert(@index, c)
        @index += 1
        if @index == @buf.length
          _print c
        else
          redraw
        end
      end
    end

    def reset
      backspace(@buf.length)
      @index, @buf = 0, ""
    end

    def redraw
      # TODO We can get away with only going back as far as index, I should
      # think
      backspace(@buf.length)
      _print @buf
    end

    def backspace(n=1)
      _print CONTROL_BS*n,BLANK*n,CONTROL_BS*n
    end

    def _print(*c)
      print *c if visible
    end

    def _puts(*c)
      puts *c if visible
    end

    def setup
      @stty_saved = `stty -g`
      `stty -echo raw`
    end

    def teardown
      `stty #{@stty_saved}`
    end

  end
end

