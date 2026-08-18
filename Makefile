SRC = _site/
WEB_USER = jimm
WEB_SERVER = jimm.opalstacked.com
WEB_DIR = apps/jimmenard
SIGS_FILE = $(pim)/signatures

.PHONY: publish build post_build resume server test

# NOTE: do not use the `--del` rsync flag or otherwise delete any files on
# the server. There are files there such as the `.well-known` directory
# that should not be checked in here and should not be deleted there.
#
# TODO: use the "P" command for --filter to protect the .well-known
# directory and re-add --del
publish: build post_build
	rsync --verbose --recursive --links --perms --times \
	  --filter='- .DS_Store' --filter='- .localized' --filter='- bin' \
	  $(SRC) $(WEB_SERVER):$(WEB_DIR)
	ssh $(WEB_USER)@$(WEB_SERVER) find $(WEB_DIR) -type d -exec chmod 755 {} \\\;

build: _includes/sigs.html
	bundle exec jekyll build

_includes/sigs.html: $(SIGS_FILE) bin/sigs.rb
	bundle exec bin/sigs.rb > $@

post_build: resume

resume:
	bin/copy_resume_pdf.sh

server:
	mkdir -p $(SRC)
	bin/copy_resume_pdf.sh
	bundle exec jekyll server
