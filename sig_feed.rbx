#!/usr/bin/env ruby

require 'rss/0.9'

HOME = ENV['HOME'] || '/home/jmenard'
SIGFILE = "#{HOME}/pim/signatures"
FIRST_LINE = "Jim Menard, jim@jimmenard.com, jim.menard@gmail.com\n"

lines = IO.readlines(SIGFILE)
lines.shift

sigs = []
sig = ''
lines.each { | line |
  if line.chomp == ''
    sigs << sig unless sig == ''
    sig = FIRST_LINE
  else
    sig << line
  end
}
sigs << sig

puts "Content-type: text/plain\n\n"

rss = RSS::Rss.new("0.9")
chan = RSS::Rss::Channel.new
chan.title = "Jim Menard's Signatures"
chan.description = "Jim Menard's signature feed"
chan.language = "en-US"
chan.link = "http://www.jimmenard.com/"
rss.channel = chan
sigs.each_with_index { |sig, i|
  item = RSS::Rss::Channel::Item.new
  item.title = sig
  item.description = "Signature #{i+1}"
  chan.items << item
}
puts rss.to_s
