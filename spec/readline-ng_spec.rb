require 'readline-ng'
require 'mocha'

# Hook to reset internal state between runs
module ReadlineNG
  class Reader
    def self.initialized=(v)
      @@initialized = v
    end
  end
end

describe ReadlineNG do

  before(:each) do
    @reader = ReadlineNG::Reader.new
    @reader.visible = false
  end

  after(:each) do
    @reader.send(:teardown)
    ReadlineNG::Reader.initialized = false
  end

  it "should only return full lines of input" do
    STDIN.stub(:read_nonblock).and_return("in", "put", "\r")
    @reader.tick # gets "in"
    @reader.lines.should be_empty
    @reader.tick # gets "put"
    @reader.lines.should be_empty
    @reader.tick
    @reader.line.should == "input"
  end

end

