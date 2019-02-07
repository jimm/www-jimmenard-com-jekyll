WEB_SERVER = jimmenard.com
WEB_DIR = webapps/htdocs

.PHONY: publish build server

# NOTE: do not use the `--del` rsync flag or otherwise delete any files on
# the server. There are files there such as the `.well-known` directory
# that should not be checked in here and should not be deleted there.
#
# TODO: use the "P" command for --filter to protect the .well-known
# directory and re-add --del
publish: build
	rsync -qrlpt --filter='- .DS_Store' --filter='- .localized' \
	    _site/ $(WEB_SERVER):$(WEB_DIR)

build:
	jekyll build

server:
	jekyll server
