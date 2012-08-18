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
    @reader.tick # gets "\r"
    @reader.line.should == "input"
  end

  it "should handle newlines in amongst inputs" do
    STDIN.stub(:read_nonblock).and_return("in", "put\racros", "slines\r...")
    @reader.tick # gets "in"
    @reader.lines.should be_empty
    @reader.tick # gets "put\racros"
    @reader.tick # gets "slines\r..."
    @reader.lines.should == ["input", "acrosslines"]
  end

  it "should call a filter method if defined" do
    STDIN.stub(:read_nonblock).and_return("in", "put")
    @reader.expects(:filter).twice
    @reader.tick
    @reader.tick
  end

  it "should let the user backspace out errors" do
    STDIN.stub(:read_nonblock).and_return("in", "put", "\x7F"*3, "tro\r")
    @reader.get_line.should == "intro"
  end

  it "should not fall over trying to backspace an empty buffer" do
    STDIN.stub(:read_nonblock).and_return("in", "\x7F"*8, "input\r")
    @reader.get_line.should == "input"
  end

  it "should respect the left key" do
    STDIN.stub(:read_nonblock).and_return("asdf", ReadlineNG::KB_LEFT*2, "__\r")
    @reader.get_line.should == "as__df"
  end

  it "should not allow the user to left before an empty buffer" do
    STDIN.stub(:read_nonblock).and_return(ReadlineNG::KB_LEFT*2, "__", ReadlineNG::KB_LEFT*2, "\r")
    @reader.get_line.should == "__"
  end

  it "should respect the right key" do
    STDIN.stub(:read_nonblock).and_return("asdf", ReadlineNG::KB_LEFT*2, "__", ReadlineNG::KB_RIGHT, "++\r" )
    @reader.get_line.should == "as_++_df"
  end

  it "should not allow the user to right after an empty buffer" do
    STDIN.stub(:read_nonblock).and_return(ReadlineNG::KB_RIGHT*2, "__", ReadlineNG::KB_RIGHT*2, "\r")
    @reader.get_line.should == "__"
  end

  it "should recieve and process single quotes" do
    STDIN.stub(:read_nonblock).and_return("'''", "\r")
    @reader.get_line.should == "'''"
  end

  it "should insert a newline from a trailing backslash" do
    STDIN.stub(:read_nonblock).and_return("rawr", ?\\, "\r", "thing", "\r")
    @reader.get_line.should == "rawr\nthing"
  end

  # TODO it "should erase the displayed line when input is terminated" do

end

