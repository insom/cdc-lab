require 'kafka'
require 'avro_turf/messaging'

logger = Logger.new(STDOUT)
kafka = Kafka.new(seed_brokers: ['localhost:9092'],
                  client_id: 'cdc-example-ruby',
                  logger: logger)

consumer = kafka.consumer(group_id: 'cdc-example-ruby')
consumer.subscribe('dbserver1.inventory.orders', start_from_beginning: true)

trap('TERM') { consumer.stop }

url = 'http://localhost:8081'
avro = AvroTurf::Messaging.new(registry_url: url)

consumer.each_message(automatically_mark_as_processed: false) do |event|
  puts event.offset, event.key, avro.decode(event.value)
end
