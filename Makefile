include Make.config
.PHONY: build open init

project_name = $(notdir $(shell pwd))
UNAME = $(shell uname)

dist = $(shell pwd)/dist
devbin = ./node_modules/.bin

docker-serve/docker-compose.yml: docker-serve/docker-compose.yml.template
	virtual_host=$(virtual_host) envsubst <$< >$@

build: node_modules app index $(dist)/app.css

index: $(dist)/index.html
$(dist)/app.css: app.less
	$(devbin)/lessc $< >$@
app: $(dist)/app.js

node_modules: package.json
	npm install

init: 
	git checkout -b master
	mkdir dist

old-serve:
	docker run --name $(project_name)-nginx -v $(dist):/usr/share/nginx/html:ro \
		-e VIRTUAL_HOST=$(project_name).localhost -d nginx

serve: docker-serve/docker-compose.yml
	docker-compose -p $(project_name) -f docker-serve/docker-compose.yml up nginx

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
	$(devbin)/nodemon --exec "make build || true" -e "less jade coffee"

docker-watch: docker-serve/docker-compose.yml 
	docker-compose -p $(project_name) -f docker-serve/docker-compose.yml up buildenv

livereload:
	$(devbin)/livereload ./dist -p $(livereload_port)

