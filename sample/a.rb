require 'threadify'

require 'open-uri'
require 'yaml'

uris =
  %w(
    http://codeforpeople.com
    http://drawohara.com
    http://twitter.com/drawohara
    http://github.com/ahoward/threadify/
    http://google.com
    http://rubyforge.org
    http://ruby-lang.org
    http://hypem.com
  )

curl = lambda{|url| open(url){|socket| socket.read}}

time 'without threadify' do
  uris.each{|uri| curl[uri]}
end


time 'with threadify' do
  uris.threadify(uris.size){|uri| curl[uri]}
end

BEGIN {
  def time label
    a = Time.now.to_f
    yield
  ensure
    b = Time.now.to_f
    puts({label => (b - a)}.to_yaml)
  end
}
