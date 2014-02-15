require 'threadify'

require 'yaml'

#size = Integer(ARGV.shift || (2 ** 20))
size = 64

haystack = Array.new(size){|i| i}
needle = 2 * (size / 3) 

a, b = 4, 2

time 'without threadify' do
  a =
    haystack.each do |value|
      break value if value == needle
      sleep(rand) # mimic work
    end
end

time 'with threadify' do
  b = 
    haystack.threadify(:each_slice, size / 8) do |slice|
      slice.each{|value| threadify! value if value == needle}
      sleep(rand) # mimic work
    end
end

raise if a != b

y({:a => a, :b => b, :needle => needle}.to_yaml)

BEGIN {
  def time label
    a = Time.now.to_f
    yield
  ensure
    b = Time.now.to_f
    y({label => (b - a)})
  end
}
