#!/usr/bin/env ruby

def ibranify latin
	# Derive orthography from input
	pron = latin.dup
	orth = latin.delete ":"
	puts " 0: = " + pron.ljust(20) + orth

	# 1: Word-final /m/ -> 0
	hit_rule =	pron.gsub! /m$/, ''
							orth.gsub! /m$/, ''
	puts " 1: = " + pron.ljust(20) + orth if hit_rule
end

ibranify ARGV[0]
