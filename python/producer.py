from kafka import KafkaProducer
import time
import datetime


producer = KafkaProducer(bootstrap_servers='localhost:9092',
                        api_version=(2, 4, 0))

while True:
    d = datetime.datetime.now()
    producer.send('some_random_topic', d.strftime('%Y-%m-%d %H:%M:%S').encode())
    print('Done')
    time.sleep(0.1)