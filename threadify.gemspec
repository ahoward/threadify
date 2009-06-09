## threadify.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "threadify"
  spec.version = "1.1.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "threadify"

  spec.files = ["lib", "lib/threadify.rb", "rakefile", "README", "README.erb", "sample", "sample/a.rb", "sample/b.rb", "threadify.gemspec"]
  spec.executables = []
  
  spec.require_path = "lib"

  spec.has_rdoc = true
  spec.test_files = nil
  #spec.add_dependency 'lib', '>= version'
  #spec.add_dependency 'fattr'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "http://github.com/ahoward/threadify/tree/master"
end
