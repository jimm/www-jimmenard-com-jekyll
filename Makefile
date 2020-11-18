WEB_SERVER = jimmenard.com
WEB_DIR = webapps/htdocs
SRC = _site/
OPAL_WEB_SERVER = jimm.opalstacked.com
OPAL_WEB_DIR = apps/jimmenard

.PHONY: publish build server opal

# NOTE: do not use the `--del` rsync flag or otherwise delete any files on
# the server. There are files there such as the `.well-known` directory
# that should not be checked in here and should not be deleted there.
#
# TODO: use the "P" command for --filter to protect the .well-known
# directory and re-add --del
publish: build
	rsync -qrlpt --filter='- .DS_Store' --filter='- .localized' \
	    $(SRC) $(WEB_SERVER):$(WEB_DIR)

# While transferring from Webfaction to Opalstack, let's keep this a
# separate target.
opal: build
	rsync -qrlpt --filter='- .DS_Store' --filter='- .localized' \
	    $(SRC) $(OPAL_WEB_SERVER):$(OPAL_WEB_DIR)

build:
	jekyll build

server:
	jekyll server
