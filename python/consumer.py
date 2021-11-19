from kafka import KafkaConsumer


consumer = KafkaConsumer('some_random_topic',
                         bootstrap_servers='localhost:9092',
                        api_version=(2, 4, 0))

for message in consumer:
    print ("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                          message.offset, message.key,
                                          message.value))