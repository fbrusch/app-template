include Make.config
.PHONY: build open init

UNAME = $(shell uname)

dist = $(shell pwd)/dist
devbin = ./node_modules/.bin

build: node_modules app index

index: $(dist)/index.html
app: $(dist)/app.js

node_modules: package.json
	npm install

init: 
	git checkout -b master
	mkdir dist
	npm install

old-serve:
	docker run --name $(project_name)-nginx -v $(dist):/usr/share/nginx/html:ro \
		-e VIRTUAL_HOST=$(project_name).localhost -d nginx

serve:
	docker-compose -f docker-serve/docker-compose.yml up nginx

stop-serve:
	docker stop $(project_name)-nginx

$(dist)/app.js: app.coffee
	$(devbin)/browserify --t coffeeify --debug $< -o $@

$(dist)/index.html: index.jade
	$(devbin)/jade \
		-P index.jade -o dist

open: $(dist)/index.html
ifeq ($(UNAME), Linux)
	xdg-open "http://$(virtual_host)" 
else
	open "http://$(virtual_host)"
endif

watch: node_modules
	$(devbin)/nodemon --exec "make build || true" -e "jade coffee"

docker-watch:
	docker-compose -p $(project_name) -f docker-serve/docker-compose.yml up buildenv

livereload:
	$(devbin)/livereload ./dist -p $(livereload_port)

