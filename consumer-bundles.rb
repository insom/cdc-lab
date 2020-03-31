# vim: foldmethod=marker:
### boilerplate you've already seen {{{1
require 'kafka'
require 'json'
$stdout.sync = true
logger = Logger.new(STDOUT, level: :error)
kafka = Kafka.new(seed_brokers: ['localhost:9092'],
                  client_id: 'cdc-consumer-bundles',
                  logger: logger)

consumer = kafka.consumer(group_id: 'cdc-consumer-bundles')
trap('TERM') { consumer.stop }
# }}}
consumer.subscribe("bundle_created", start_from_beginning: true)

consumer.each_message(automatically_mark_as_processed: false) do |event|
  event = JSON.load(event.value[8...1000000]) # don't look
  puts "A new bundle has been created, its made up of the following products:"
  event["products"].map(&method(:p))
end
