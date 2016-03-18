WEB_SERVER = jimmenard.com
WEB_DIR = webapps/htdocs

.PHONY: publish build server

publish: build
	rsync -qrlpt --filter='exclude .DS_Store' --del _site/ $(WEB_SERVER):$(WEB_DIR)

build:
	jekyll build

server:
	jekyll server
