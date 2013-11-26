## Service Discovery With Docker
This repo is a proof of concept to test out service discovery with Docker and [Etcd](https://github.com/coreos/etcd). The setup for the test, is

- Provide access to a Java app running in a Docker container with a fixed name/port
- This Java app makes a call to another Java app via an address that it discovers
- The second Java app connects to and uses an instance of Memcached


See also, this same [test with Docker links](https://github.com/benschw/docker-service-discovery-with-links)

ps. this test also implements load balancing between the Java services 
pss. this test makes use of two additional components. They are both published to [Docker Index](https://index.docker.io/u/benschw/), but are also shared on github: 
- [etcdedge](https://github.com/benschw/etcdedge) a python service to sync etcd configuration to redis for hipache to use in routing "edge" traffic
- [etcdbridge](https://github.com/benschw/etcdbridge) a python service to monitor the health of my docker containers and publish their addresses to etcd.

## Build & Run

add the following to your host file

	127.0.0.1 client.local

build the project

	./gradlew shadow

build the container image

	sudo docker build -t app .

Deploy the test environment

	sudo ./run.sh

Beat up the environment (and watch the list of random numbers grow with each request)

	curl http://client.local/demo
