require 'timeout'

def succeed_on_attempt number
  @attempt ||= 0
  puts @attempt
  @attempt += 1
  if @attempt == number
    puts "Success!"
    @attempt
  else
    sleep 1
    nil
  end
end

puts "About to do some potentially failing operation"

module Sleepy

  def initialize
    @result = nil
  end

  def within seconds=1, &block
    begin
      Timeout::timeout(seconds) do |timeout_length|
        #puts "the timeout period is #{timeout_length}"
        until @result 
          @result = yield
          sleep(0.5)
        end
        @result
      end
    rescue Timeout::Error
      @result 
    end
  end

end

RSpec.configure do |config|
  config.include(Sleepy)
  class Fixnum
    def seconds; self end
  end

  class Float
    def seconds; self end
  end
end

describe "something that needs sleepy" do

  context "when the block returns true within the timeout" do
    it "returns the value of the block" do
      within(0.5.seconds) { succeed_on_attempt 1 }.should == 1
    end
  end

  context "when the block does not return true within the timeout" do
    it "returns the value of the block" do
      within(0.5.seconds) { nil }.should ==  nil
    end
  end

end
