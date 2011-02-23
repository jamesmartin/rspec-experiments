class Sleepy
  def within &block
    yield
  end
end

describe "sleepy" do

  before(:each) do
    @sleepy = Sleepy.new
  end

  def succeed_on_attempt number
    @attempt ||= 0
    puts @attempt
    @attempt += 1
    if @attempt == number
      @attempt
    else
      nil
    end
  end

  it "returns the value of a block if the value is truthy" do
    @sleepy.within { "hello" }.should == "hello"
  end

end
