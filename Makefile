include Make.config
.PHONY: build open init

UNAME = $(shell uname)

dist = $(shell pwd)/dist
#livereload_port = 45870
devbin = ./node_modules/.bin

build: app index

index: $(dist)/index.html
app: $(dist)/app.js

init: 
	git checkout -b master
	mkdir dist

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
	$(devbin)/jade -O \
		"{livereloadUrl:'http://localhost:$(livereload_port)/livereload.js'}" \
		-P index.jade -o dist

open: $(dist)/index.html
ifeq ($(UNAME), Linux)
	xdg-open $<
else
	open $<
endif

watch:
	$(devbin)/nodemon --exec "make build || true" -e "jade coffee"

livereload:
	$(devbin)/livereload ./dist -p $(livereload_port)

