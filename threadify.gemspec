## threadify.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "threadify"
  spec.version = "1.4.4"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "threadify"
  spec.description = "makes it stupid easy to process a bunch of data using n worker threads"
  spec.license = "same as ruby's"

  spec.files =
["README",
 "README.erb",
 "Rakefile",
 "lib",
 "lib/threadify.rb",
 "sample",
 "sample/a.rb",
 "sample/b.rb",
 "threadify.gemspec"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

### spec.add_dependency 'lib', '>= version'
#### spec.add_dependency 'map'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/threadify"
end
