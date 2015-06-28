FROM node:latest
RUN apt-get update
RUN apt-get install -y make git
RUN npm install -g nodemon livereload browserify coffeeify
WORKDIR /src
CMD make watch

