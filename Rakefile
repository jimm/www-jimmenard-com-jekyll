WEB_SERVER = 'jimmenard.com'
WEB_DIR = "webapps/htdocs"

task :default => :server

desc "copy everything up to server"
task :publish => [:build] do
  # NOTE: do not use the `--del` rsync flag or otherwise delete any files on
  # the server. There are files there such as the `.well-known` directory
  # that should not be checked in here and should not be deleted there.
  system("rsync -qrlpt --filter='exclude .DS_Store' _site/ #{WEB_SERVER}:#{WEB_DIR}")
end

task :server do
  system("jekyll server")
end

task :build do
  system("jekyll build")
end
