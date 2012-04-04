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
        yield @buf.slice!(0)
      end
    end

  end
end
