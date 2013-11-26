FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:webupd8team/java -y

RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install -y oracle-java7-installer


ADD ./src/dist/config/app.yml /opt/app.yml
ADD ./build/libs/discovery-0.1.jar /opt/app.jar

EXPOSE 8080 8081

CMD /usr/bin/java -jar /opt/app.jar server /opt/app.yml
