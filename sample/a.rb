require 'open-uri'
require 'yaml'

require 'rubygems'
require 'threadify'


uris =
  %w(
    http://google.com
    http://yahoo.com
    http://rubyforge.org
    http://ruby-lang.org
    http://kcrw.org
    http://drawohara.com
    http://codeforpeople.com
  )


time 'without threadify' do
  uris.each do |uri|
    body = open(uri){|pipe| pipe.read}
  end
end


time 'with threadify' do
  uris.threadify do |uri|
    body = open(uri){|pipe| pipe.read}
  end
end


BEGIN {
  def time label
    a = Time.now.to_f
    yield
  ensure
    b = Time.now.to_f
    y label => (b - a)
  end
}
