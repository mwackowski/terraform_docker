
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


terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "kafka" {
  name = "wurstmeister/kafka:latest"
}

resource "docker_image" "zookeeper" {
  name = "wurstmeister/zookeeper:latest"
}

resource "docker_image" "kafka-manager" {
  name = "hlebalbau/kafka-manager:stable"
}


resource "docker_container" "kafka" {

  name  = "kafka"
  image = "wurstmeister/kafka:latest"
  #   hostname = "kafka"

networks = ["kafkanet"]

  #   must_run = true
  #   publish_all_ports = true
  #   command = [
  #     "tail",
  #     "-f",
  #     "/dev/null"
  #   ]

  ports {
    external = 9092
    internal = 9092
  }

  env = [
    "KAFKA_ADVERTISED_HOST_NAME=localhost",
    "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181",
    "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1",
    "KAFKA_MIN_INSYNC_REPLICAS=1",
  ]
}

resource "docker_container" "zookeeper_container" {

  name = "zookeeper"
  #   hostname = "zookeeper"
  image = "wurstmeister/zookeeper:latest"

  ports {
    external = 2181
    internal = 2181
  }

  #   links = ["kafka"]

  networks = ["kafkanet"]
}


resource "docker_container" "kafka_manager" {

  name  = "kafka_manager"
  image = "hlebalbau/kafka-manager:stable"

  ports {
    external = 9000
    internal = 9000
  }

  env = [
    "ZK_HOSTS=zookeeper:2181",
    "APPLICATION_SECRET=random-secret"
  ]

  command = ["-Dpidfile.path=/dev/null"]

  networks = ["kafkanet"]

  #   links = ["kafka"]

}

resource "docker_network" "kafkanet" {
  name   = "kafkanet"
  driver = "bridge"
}
