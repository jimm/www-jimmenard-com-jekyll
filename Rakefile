SSH_TARGET = "jmenard@jimmenard.com"
SITE_DIR = "webapps/htdocs"
LOCAL_HTML_TARGET = "/Library/WebServer/Documents"
LOCAL_CGI_TARGET = "/Library/WebServer/CGI-Executables"

task :default => :local

desc "copy everything up to server"
task :publish do
  system("ssh #{SSH_TARGET} 'cd #{SITE_DIR} && git pull'")
end

desc "copy everything to local Mac Web server"
task :local do
  system <<EOS
rm -rf #{LOCAL_HTML_TARGET}/* #{LOCAL_CGI_TARGET}/*
cp -r * #{LOCAL_HTML_TARGET}
cp *.rbx *.cgi #{LOCAL_CGI_TARGET}
ruby -pi.bak -e 'sub(%r{/home/jmenard}, \"#{ENV['HOME']}\")' #{LOCAL_CGI_TARGET}/*.rbx
rm #{LOCAL_CGI_TARGET}/*.rbx.bak
EOS
end
