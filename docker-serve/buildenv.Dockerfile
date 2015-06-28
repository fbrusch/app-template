FROM ubuntu
RUN apt-get update
RUN apt-get install -y make git nodejs npm
RUN ln /usr/bin/nodejs /usr/bin/node
RUN npm install -g nodemon livereload browserify coffeeify
WORKDIR /src
CMD make watch

