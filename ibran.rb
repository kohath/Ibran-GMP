#!/usr/bin/env ruby

def ibranify latin
	@pron, @orth = latin.dup, latin.dup

	# Derive orthography from input
	change 0, {}, {/:/ => ""}

	# 1: Word-final /m/ -> 0
	change 1, {/m$/ => ''}
	
	# 2: /mn/ -> /nn/
	change 2, {/mn/ => 'nn'}
end

def change rule, pron_changes, orth_changes = pron_changes
	hit_phon = pron_changes.keys.inject(nil) do |hit, key|
		hit ||= @pron.gsub! key, pron_changes[key]
	end

	hit_orth = orth_changes.keys.inject(nil) do |hit, key|
		hit ||= @orth.gsub! key, orth_changes[key]
	end

	print_change rule, @pron, @orth if hit_phon || hit_orth
end

def print_change rule, pron, orth
	puts rule.to_s.rjust(3) + " = " + pron.ljust(20) + orth
end

ibranify ARGV[0]
