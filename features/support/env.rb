require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'bio-rdf'

require 'rspec/expectations'

if `4s-backend-info biorubyrdftest` !~ /disk usage/
  print "Initializing 4store for testing bioruby-rdf...\n"
  print `4s-backend-setup biorubyrdftest`
  print `4s-backend biorubyrdftest`
  print `4s-httpd -p 8000 biorubyrdftest`
end
