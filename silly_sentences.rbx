#!/usr/bin/env ruby

the = ["the","a","an"]
nouns = ["wind", "candle", "ruby"]
verbs = ["smell", "run", "read"]
adjectives = ["gluey", "steaming", "stupid"]
punctuation = [".", "!","?"]

noun = nouns[rand(3)] 
verb = verbs[rand(3)]
adjective = adjectives[rand(3)]
punctuation = punctuation[rand(3)]
the = the [rand(3)]

puts                            # Blank line after headers
puts "#{the.capitalize} #{noun} #{verb}s #{adjective}#{punctuation}"
