## Service Discovery With Docker
This repo is a proof of concept to test out service discovery with Docker and [Etcd](https://github.com/coreos/etcd). The setup for the test, is

- Provide access to a Java app running in a Docker container with a fixed name/port
- This Java app makes a call to another Java app via an address that it discovers
- The second Java app connects to and uses an instance of Memcached


See also, this same [test with Docker links](https://github.com/benschw/docker-service-discovery-with-links)

n.b. this test also implements load balancing between the Java services

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
