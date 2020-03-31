require 'kafka'
require 'avro_turf/messaging'

$stdout.sync = true
logger = Logger.new(STDOUT, level: :info)
kafka = Kafka.new(seed_brokers: ['localhost:9092'],
                  client_id: 'cdc-example-ruby',
                  logger: logger)

consumer = kafka.consumer(group_id: 'cdc-example-ruby')
consumer.subscribe("dbserver1.inventory.#{ ARGV[0] }", start_from_beginning: false)

trap('TERM') { consumer.stop }

url = 'http://localhost:8081'
avro = AvroTurf::Messaging.new(registry_url: url)

consumer.each_message(automatically_mark_as_processed: false) do |event|
  puts avro.decode(event.value)
end
