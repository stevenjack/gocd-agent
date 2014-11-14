FROM java:7
MAINTAINER Steven Jack, stevenmajack@gmail.com

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl unzip git subversion mercurial

RUN curl -L -o /tmp/go-agent.deb http://download.go.cd/gocd-deb/go-agent-14.2.0-377.deb
RUN dpkg -i /tmp/go-agent.deb
RUN rm /tmp/go-agent.deb

RUN sed -r -i "s/^(GO_SERVER)=(.*)/\1=\$SERVER_PORT_8153_TCP_ADDR/g" /etc/default/go-agent
RUN sed -r -i "s/^(DAEMON)=(.*)/\1=\N/g" /etc/default/go-agent

VOLUME ["/var/lib/go-agent"]

ADD ssh_config /etc/ssh/ssh_config

CMD /usr/lib/jvm/java-7-openjdk-amd64/bin/java -jar /usr/share/go-agent/agent-bootstrapper.jar $SERVER_PORT_8153_TCP_ADDR $SERVER_PORT_8153_TCP_PORT
