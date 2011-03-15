require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'lib/multiparams_for_strings'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)


load 'test/db/schema.rb'

Dir['test/db/app/models/**/*.rb'].each { |f| require f }


