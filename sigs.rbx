#!/usr/bin/env ruby

require 'cgi'

SIGS_FILE = '/home/jmenard/pim/signatures'

puts                            # Blank line after headers
begin
  puts '<pre>'
  IO.foreach(SIGS_FILE) { | line |
    puts CGI::escapeHTML(line.chomp).sub(/\s*---?\s*/, ' &mdash; ')
  }
  puts '</pre>'
rescue => ex
  p ex
end
