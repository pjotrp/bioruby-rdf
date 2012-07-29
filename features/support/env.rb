require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

rootdir = File.dirname(__FILE__) + '/../..'
$LOAD_PATH.unshift(rootdir+'/lib',rootdir+'/../bioruby-table/lib')

# p $:

require 'bio-rdf'

require 'rspec/expectations'

if `which 4s-backend` !~ /4s-backend/
  raise "Can not find 4store 4s-backend tool in path!"
end
if `4s-backend-info biorubyrdftest` !~ /disk usage/
  print "Initializing 4store for testing bioruby-rdf on http://localhost:8000/\n"
  print `4s-backend-setup biorubyrdftest`
  if $?.exitstatus > 0
    raise "You may have to add yourself to the 4store group"
  end
  print `4s-backend biorubyrdftest`
  print `4s-httpd -p 8000 biorubyrdftest`
end
