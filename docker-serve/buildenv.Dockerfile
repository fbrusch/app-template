FROM ubuntu
RUN apt-get update
RUN apt-get install -y make git nodejs npm
RUN ln /usr/bin/nodejs /usr/bin/node
WORKDIR /src
CMD make watch

