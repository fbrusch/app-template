# app-template
Template for html app with nodemon, livereload, browserify, coffee

Usage: 

Edit Make.conf and docker-serve/docker-compose.yml to set virtual_host

    make init
    npm install
    make serve (requires docker, docker-compose, and running docker nginx-proxy)
    make watch &
    make open
  
Edit index.jade and app.coffee, and you're good to go!

If you want to change something in the template: 
    
    git checkout template

    [your modifications]

    [git add + commit]

    git checkout master
    git rebase template

