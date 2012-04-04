module ReadlineNG
  class ChunkedString

    def initialize(str="")
      @buf = str
    end

    def <<(str)
      @buf += str
    end

    def each_chunk
      until @buf.empty?
        t = @buf.slice!(0)
        if t == "\e"
          t += @buf.slice!(0..1)
        end

        yield t
      end
    end

  end
end
