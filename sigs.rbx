#!/usr/bin/env ruby

require 'cgi'

SIGS_FILE = '/home/jmenard/pim/signatures'

def process(line)
  line.chomp!
  line.sub!(/\s*---?\s*/, ' &mdash; ')

  # special cases
  if line =~ /_why the lucky stiff_/
    return line
  end
  line.gsub(%r{\b_(.*)_\b}, '<em>\1</em>')
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
