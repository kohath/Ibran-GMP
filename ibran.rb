#!/usr/bin/env ruby

ibranify ARGV[0]

def ibranify latin
	# Derive orthography from input
	orth = latin.delete ":"
	puts " 0: = " + latin.ljust(20) + orth

	# Word-final /m/ -> 0
	
end
