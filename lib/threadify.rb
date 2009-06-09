module Threadify
  Threadify::VERSION = '1.2.0' unless defined?(Threadify::VERSION)
  def Threadify.version() Threadify::VERSION end

  require 'thread'
  require 'enumerator'

  @threads = 8
  @abort_on_exception = true
  @strategy = [:each]

  class << self
    attr_accessor :threads
    attr_accessor :abort_on_exception
    attr_accessor :strategy
  end

  class Error < ::StandardError; end
end

module Enumerable
  def threadify(*args, &block)
  # setup
  #
    opts = args.last.is_a?(Hash) ? args.pop : {}
    opts.keys.each{|key| opts[key.to_s.to_sym] = opts.delete(key)}
    opts[:threads] ||= (Numeric === args.first ? args.shift : Threadify.threads)
    opts[:strategy] ||= (args.empty? ? Threadify.strategy : args)

    threads = Integer(opts[:threads])
    strategy = opts[:strategy]
    done = Object.new.freeze
    nothing = done
    jobs = Array.new(threads).map{ [] }
    top = Thread.current

  # produce jobs
  #
    i = 0
    send(*strategy){|*args| jobs[i % threads].push([args, i]); i += 1}
    threads.times{|i| jobs[i].push(done)}

  # setup consumer list
  #
    consumers = Array.new threads 

  # setup support for short-circuit bailout via 'throw :threadify'
  #
    thrownv = Hash.new
    thrownq = Queue.new

    caught = false

    catcher = Thread.new do
      loop do
        thrown = thrownq.pop
        break if thrown == done
        i, thrown = thrown
        thrownv[i] = thrown
        caught = true
      end
    end

  # fire off the consumers
  #
    threads.times do |i|
      consumers[i] = Thread.new(jobs[i]) do |jobsi|
        this = Thread.current
        this.abort_on_exception = Threadify.abort_on_exception
    
        job = nil

        thrown =
          catch(:threadify) do
            loop{
              break if caught
              job = jobsi.shift
              break if job == done
              args = job.first
              jobsi << (job << block.call(*args))
            }
            nothing
          end


        unless nothing == thrown
          thrownq.push [i, thrown]
          args, i = job
        end
      end
    end

  # wait for consumers to finish
  #
    consumers.map{|t| t.join}

  # nuke the catcher
  #
    thrownq.push done
    catcher.join

  # iff something(s) was thrown return the one which would have been thrown
  # earliest in non-parallel execution
  #
    unless thrownv.empty?
      key = thrownv.keys.sort.first
      return thrownv[key]
    end

  # collect the results and return them
  #
    ret = []
    jobs.each do |results|
      results.each do |result|
        break if result == done
        elem, i, value = result
        ret[i] = value
      end
    end
    ret
  end

end

class Thread
  def Thread.ify(enumerable, *args, &block)
    enumerable.send :threadify, *args, &block
  end
end

class Object
  def threadify!(*values)
    throw :threadify, *values
  end
end


if __FILE__ == $0
  require 'open-uri'
  require 'yaml'

  uris = %w( http://google.com http://yahoo.com http://rubyforge.org/ http://ruby-lang.org)

  Thread.ify uris, :threads => 3 do |uri|
    body = open(uri){|pipe| pipe.read}
    y uri => body.size
  end
end


__END__

sample output

--- 
http://yahoo.com: 9562
--- 
http://google.com: 6290
--- 
http://rubyforge.org/: 22352
--- 
http://ruby-lang.org: 9984
