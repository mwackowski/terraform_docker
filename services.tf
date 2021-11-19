
# resource "docker_service" "kafka" {
#   name = "kafka"

#   task_spec {
#     container_spec {
#         image = "wurstmeister/kafka"

#         env = {
#             KAFKA_ADVERTISED_HOST_NAME = "localhost",
#             KAFKA_ZOOKEEPER_CONNECT = "zookeeper:2181",
#             KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR = "1",
#             KAFKA_MIN_INSYNC_REPLICAS = "1"              
#         }
#         command = [
#             "tail",
#             "-f",
#             "/dev/null"
#         ]
#     }
#   }

#   mode {
#     replicated {
#       replicas = 1
#     }
#   }

#   endpoint_spec {
#     ports {
#       published_port = 9092
#       target_port    = 9092
#     }
#   }
# }


# resource "docker_service" "zookeeper" {
#   name = "zookeeper"

#   task_spec {
#     container_spec {
#       image = "wurstmeister/zookeeper"
#     }
#   }

#    endpoint_spec {
#     ports {
#       published_port = 2181
#       target_port    = 2181
#     }
#   }
# }

# resource "docker_service" "kafka_manager" {
#   name = "kafka_manager"

#   task_spec {
#     container_spec {
#         image = "hlebalbau/kafka-manager:stable"

#         env = {
#             ZK_HOSTS = "zookeeper:2181",
#             APPLICATION_SECRET = "random-secret"       
#         }

#         command = [
#                         "tail",
#             "-f",
#             "/dev/null",
#             # "-Dpidfile.path/dev/null",

#         ]
#     }
#   }

#     endpoint_spec {
#     ports {
#       published_port = 9000
#       target_port    = 9000
#     }
#   }
# }
