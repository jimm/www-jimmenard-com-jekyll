WEB_SERVER = 'jimmenard.com'
WEB_DIR = "webapps/htdocs"

task :default => :server

desc "copy everything up to server"
task :publish => [:build] do
  system("rsync -qrlpt --filter='exclude .DS_Store' --del _site/ #{WEB_SERVER}:#{WEB_DIR}")
end

task :server do
  system("jekyll server")
end

task :build do
  system("jekyll build")
end
