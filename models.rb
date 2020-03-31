require 'active_record'
require 'pedant_mysql2'

ActiveRecord::Base.establish_connection(
  :adapter => 'pedant_mysql2',
  :host => '127.0.0.1', # not localhost (for raisins)
  :port => 3306,
  :username => 'mysqluser',
  :password => 'mysqlpw',
  :database => 'inventory'
)

class Product < ActiveRecord::Base
 # id
 # name (required)
 # description
 # weight
end
