#!/bin/bash

docker_bridge_ip=$(/sbin/ifconfig docker0 | sed -n '2 p' | awk '{print $2}' | cut -d":" -f2)
etcd_ip=$(/sbin/ifconfig docker0 | sed -n '2 p' | awk '{print $2}' | cut -d":" -f2)


echo "Start Hipache and Redis"
docker run -d -p 6379:6379 -p 80:80 hipache supervisord -n

echo "Start Etcd"
docker run -d -p 4001:4001 -p 7001:7001 benschw/etcd

sleep 5 # etcd and redis don't seem to be ready immediately

echo "Start EtcdEdge"
docker run -d -e ETCD=$etcd_ip:4001 -e REDIS=$docker_bridge_ip:6379 -e DEBUG=true benschw/etcdedge


echo "Start Memcached"
memcache_id=$(docker run -d -p 11211 benschw/memcached)
memcache_port=$(docker port $memcache_id 11211 | awk -F: '{print $2}')
memcache_hc="echo quit | telnet $docker_bridge_ip $memcache_port | grep Connected"

docker run -d \
		-e CONTAINER_ID=$memcache_id \
		-e SERVICE_ID=memcached \
		-e APPLICATION_ADDRESS=$docker_bridge_ip:$memcache_port \
		-e HEALTH_CHECK="$memcache_hc" \
		-e ETCD=$etcd_ip:4001 \
		-e DEBUG=true \
		benschw/etcdbridge


echo "Start App (Service role)"
service_id=$(docker run -d -p 8080 -p 8081 -e ETCD="http://$etcd_ip:4001" benschw/service-discovery-etcd-example:latest)
service_port=$(docker port $service_id 8080 | awk -F: '{print $2}')
service_admin_port=$(docker port $service_id 8081 | awk -F: '{print $2}')
service_hc="curl -s -L -I http://$docker_bridge_ip:$service_admin_port/healthcheck | grep 'HTTP/1.1 200 OK'"

docker run -d \
		-e CONTAINER_ID=$service_id \
		-e SERVICE_ID=service \
		-e APPLICATION_ADDRESS=$docker_bridge_ip:$service_port \
		-e HEALTH_CHECK="$service_hc" \
		-e ETCD=$etcd_ip:4001 \
		-e DEBUG=true \
		benschw/etcdbridge

echo "Start App (Service role)"
service_id=$(docker run -d -p 8080 -p 8081 -e ETCD="http://$etcd_ip:4001" benschw/service-discovery-etcd-example:latest)
service_port=$(docker port $service_id 8080 | awk -F: '{print $2}')
service_admin_port=$(docker port $service_id 8081 | awk -F: '{print $2}')
service_hc="curl -s -L -I http://$docker_bridge_ip:$service_admin_port/healthcheck | grep 'HTTP/1.1 200 OK'"

docker run -d \
		-e CONTAINER_ID=$service_id \
		-e SERVICE_ID=service \
		-e APPLICATION_ADDRESS=$docker_bridge_ip:$service_port \
		-e HEALTH_CHECK="$service_hc" \
		-e ETCD=$etcd_ip:4001 \
		-e DEBUG=true \
		benschw/etcdbridge


echo "Start App (Client role)"
client_id=$(docker run -d -p 8080 -p 8081 -e ETCD="http://$etcd_ip:4001" benschw/service-discovery-etcd-example:latest)
client_port=$(docker port $client_id 8080 | awk -F: '{print $2}')
client_admin_port=$(docker port $client_id 8081 | awk -F: '{print $2}')
client_hc="curl -s -L -I http://$docker_bridge_ip:$client_admin_port/healthcheck | grep 'HTTP/1.1 200 OK'"

docker run -d \
		-e HOST_NAME="client.local" \
		-e CONTAINER_ID=$client_id \
		-e SERVICE_ID=client \
		-e APPLICATION_ADDRESS=$docker_bridge_ip:$client_port \
		-e HEALTH_CHECK="$client_hc" \
		-e ETCD=$etcd_ip:4001 \
		-e DEBUG=true \
		benschw/etcdbridge

echo "Start App (Client role)"
client_id=$(docker run -d -p 8080 -p 8081 -e ETCD="http://$etcd_ip:4001" benschw/service-discovery-etcd-example:latest)
client_port=$(docker port $client_id 8080 | awk -F: '{print $2}')
client_admin_port=$(docker port $client_id 8081 | awk -F: '{print $2}')
client_hc="curl -s -L -I http://$docker_bridge_ip:$client_admin_port/healthcheck | grep 'HTTP/1.1 200 OK'"

docker run -d \
		-e HOST_NAME="client.local" \
		-e CONTAINER_ID=$client_id \
		-e SERVICE_ID=client \
		-e APPLICATION_ADDRESS=$docker_bridge_ip:$client_port \
		-e HEALTH_CHECK="$client_hc" \
		-e ETCD=$etcd_ip:4001 \
		-e DEBUG=true \
		benschw/etcdbridge


