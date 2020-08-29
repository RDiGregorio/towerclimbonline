# This file must be edited with the GitHub username and passwords.

FROM tomcat
RUN apt-get update
RUN apt install sudo
RUN apt-get install -y certbot
RUN apt-get install apt-transport-https
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update
RUN apt-get install dart
WORKDIR /root
RUN git clone https://username:password@github.com/eris11001100/towerclimbonline.git
WORKDIR /root/towerclimbonline
RUN /usr/lib/dart/bin/pub upgrade
RUN /usr/lib/dart/bin/pub global activate webdev
RUN /root/.pub-cache/bin/webdev build
RUN rm -rf /usr/local/tomcat/webapps/ROOT
RUN cp -rf ./build /usr/local/tomcat/webapps/ROOT