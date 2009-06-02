#! /usr/bin/env ruby

template = <<-__
  NAME
    threadify.rb

  SYNOPSIS
    enumerable = %w( a b c d )
    enumerable.threadify(2){ 'process this block using two worker threads' }

  DESCRIPTION
    threadify.rb makes it stupid easy to process a bunch of data using 'n'
    worker threads

  INSTALL
    gem install threadify

  URI
    http://rubyforge.org/projects/codeforpeople

  SAMPLES
    <%= samples %>

  HISTORY
    1.0.0
      - adjust threadify to yield objects exactly like Enumerable#each

    0.0.3
      - added ability to short-circuit the parallel processing, a.k.a to 'break'
        from threadify

    0.0.2
      - don't use thread.exit, just let the thread die naturally
      - add version to Threadify module
      - comments ;-)
__


require 'erb'
require 'pathname'

$VERBOSE=nil

def indent(s, n = 2)
  s = unindent(s)
  ws = ' ' * n
  s.gsub(%r/^/, ws)
end

def unindent(s)
  indent = nil
  s.each do |line|
    next if line =~ %r/^\s*$/
    indent = line[%r/^\s*/] and break
  end
  indent ? s.gsub(%r/^#{ indent }/, "") : s
end

samples = ''
prompt = '~ > '

Dir.chdir(File.dirname(__FILE__))

Dir['sample*/*'].sort.each do |sample|
  samples << "\n" << "  <========< #{ sample } >========>" << "\n\n"

  cmd = "cat #{ sample }" 
  samples << indent(prompt + cmd, 2) << "\n\n" 
  samples << indent(`#{ cmd }`, 4) << "\n" 

  cmd = "ruby #{ sample }" 
  samples << indent(prompt + cmd, 2) << "\n\n" 

  cmd = "ruby -e'STDOUT.sync=true; exec %(ruby -Ilib #{ sample })'" 
  #cmd = "ruby -Ilib #{ sample }" 
  samples << indent(`#{ cmd } 2>&1`, 4) << "\n" 
end

erb = ERB.new(unindent(template))
result = erb.result(binding)
#open('README', 'w'){|fd| fd.write result}
#puts unindent(result)
puts result
