require 'yaml'

require 'rubygems'
require 'threadify'

size = Integer(ARGV.shift || (2 ** 15))

haystack = Array.new(size){|i| i}
needle = 2 * (size / 3) 

a, b = 4, 2

time 'without threadify' do
  a = haystack.each{|value| break value if value == needle}
end

time 'with threadify' do
  b = haystack.threadify(16){|value| threadify! value if value == needle}
end

raise if a != b

y :a => a, :b => b, :needle => needle

BEGIN {
  def time label
    a = Time.now.to_f
    yield
  ensure
    b = Time.now.to_f
    y label => (b - a)
  end
}
