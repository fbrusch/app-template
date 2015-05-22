include Make.config
.PHONY: build open

dist = dist
#livereload_port = 45870
devbin = ./node_modules/.bin

build: app index

index: $(dist)/index.html
app: $(dist)/app.js

$(dist)/app.js: app.coffee
	$(devbin)/browserify --t coffeeify --debug $< -o $@

$(dist)/index.html: index.jade
	$(devbin)/jade -O \
		"{livereloadUrl:'http://localhost:$(livereload_port)/livereload.js'}" \
		-P index.jade -o dist

open:
	open dist/index.html

watch:
	$(devbin)/nodemon --exec "make build" -e "jade coffee"

livereload:
	$(devbin)/livereload ./dist -p $(livereload_port)

