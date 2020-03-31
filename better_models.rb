# vim: foldmethod=marker:
### boilerplate you've already seen {{{1
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
# }}}
require 'json'

class OutboxEvent < ActiveRecord::Base
 self.table_name = 'outbox_event'
 self.inheritance_column = 'pls_no_thx'

 def self.emit_json(topic, structure)
   self.create(aggregatetype: topic, aggregateid: 1,
               type: 'dunnolol', payload: JSON.dump(structure))
 end
end

class Product < ActiveRecord::Base
  def as_json
    {name: name, id: id}
  end
end

def create_a_twin_pack(first_product_name, second_product_name)
  Product.transaction do
    first_product = Product.create(name: first_product_name)
    second_product = Product.create(name: second_product_name)
    OutboxEvent.emit_json('bundle_created', {
      products: [first_product.as_json, second_product.as_json]
    })
  end
end

# create_a_twin_pack("twix", "aero")
