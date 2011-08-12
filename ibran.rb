#!/usr/bin/env ruby

def ibranify latin
	# Derive orthography from input
	orth = latin.delete ":"
	puts " 0: = " + latin.ljust(20) + orth

	# Word-final /m/ -> 0
	
end

ibranify ARGV[0]
