#!/bin/bash

redis_conf() {
cat <<EOF > /etc/sensu/conf.d/redis.json 
{
  "redis": {
    "host": "${REDIS_HOSTNAME:-localhost}",
    "port": ${REDIS_PORT:-6379}
  }
}
EOF
}

rabbitmq_conf() {
cat <<EOF > /etc/sensu/conf.d/rabbitmq.json 
{
  "rabbitmq": {
    "host": "${RABBITMQ_HOSTNAME:-localhost}",
    "port": ${RABBITMQ_PORT:-5671},
    "vhost": "${RABBITMQ_VHOST:-/sensu}",
    "user": "${RABBITMQ_USER:-sensu}",
    "password": "${RABBITMQ_PASSWORD:-password}",
    "heartbeat": ${RABBITMQ_HEARTBEAT:-30},
    "prefetch": ${RABBITMQ_PREFETCH:-50},
    "ssl": {
      "cert_chain_file": "${RABBITMQ_CERT_FILE:-/etc/sensu/ssl/cert.pem}",
      "private_key_file": "${RABBITMQ_KEY_FILE:-/etc/sensu/ssl/key.pem}"
    }
  }
}
EOF
}

case $SENSU_MODE in
server) redis_conf
rabbitmq_conf
/opt/sensu/bin/sensu-server
;;
api) redis_conf
rabbitmq_conf
/opt/sensu/bin/sensu-api
;;
client) rabbitmq_conf
/opt/sensu/bin/sensu-client
;;
*) echo "Please select SENSU_MODE server,api or client"
sleep 5000
;;
esac
