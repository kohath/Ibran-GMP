#!/usr/bin/env ruby

def ibranify latin
	# Derive orthography from input
	pron = latin.dup
	orth = latin.delete ":"
	print_change 0, pron, orth

	# 1: Word-final /m/ -> 0
	hit_rule =	pron.gsub! /m$/, ''
							orth.gsub! /m$/, ''
	print_change 1, pron, orth if hit_rule
	
	# 2: /mn/ -> /nn/
	hit_rule = pron.gsub! /mn/, 'nn'
						 orth.gsub! /mn/, 'nn'
	print_change 2, pron, orth if hit_rule
end

def print_change rule, pron, orth
	puts rule.to_s.rjust(3) + " = " + pron.ljust(20) + orth
end

ibranify ARGV[0]
