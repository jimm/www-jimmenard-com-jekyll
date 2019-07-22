#!/usr/bin/env ruby

require 'cgi'

SIGS_FILE = '/home/jmenard/pim/signatures'

def process(line)
  line
    .chomp
    .gsub(%r{\b_(.*)_\b}, '<em>\1</em>')
    .sub(/\s*---?\s*/, ' &mdash; ')
end

puts                            # Blank line after headers
begin
  puts '<pre>'
  IO.foreach(SIGS_FILE) { | line |
    puts process(line)
  }
  puts '</pre>'
rescue => ex
  p ex
end
