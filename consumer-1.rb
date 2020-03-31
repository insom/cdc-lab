# vim: foldmethod=marker:
### boilerplate you've already seen {{{1
require 'kafka'
require 'avro_turf/messaging'
$stdout.sync = true
logger = Logger.new(STDOUT, level: :error)
kafka = Kafka.new(seed_brokers: ['localhost:9092'],
                  client_id: 'cdc-consumer-1',
                  logger: logger)

consumer = kafka.consumer(group_id: 'cdc-consumer-1')
consumer.subscribe("dbserver1.inventory.products", start_from_beginning: false)

trap('TERM') { consumer.stop }

url = 'http://localhost:8081'
avro = AvroTurf::Messaging.new(registry_url: url)
### }}}

consumer.each_message(automatically_mark_as_processed: false) do |event|
  event = avro.decode(event.value)
  case event["op"]
  when 'c'
    name = event["after"]["name"]
    puts "A new product was created, and its name is '#{ name }'"
  when 'd'
    name = event["before"]["name"]
    puts "A product was deleted, and its name was '#{ name }'"
  when 'u'
    old_name = event["before"]["name"]
    new_name = event["after"]["name"]
    puts "A product was updated from '#{ old_name }' to '#{ new_name }'"
  end
end
