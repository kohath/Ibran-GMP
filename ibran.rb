#!/usr/bin/env ruby

SHORT = '[aeiouy]'
V = '[aeiouy]:?'
C = '[bcdfghklmnpqrstxz]'

def ibranify latin
	@pron, @orth = latin.dup, latin.dup

	# Derive orthography from input
	change 0, {}, {/:/ => ""}

	# 1: Word-final /m/ -> 0
	change 1, {/m$/ => ''}
	
	# 2: /mn/ -> /nn/
	change 2, {/mn/ => 'nn'}
	
	# 3: Word-final /t/ -> 0
	change 3, {/t$/ => ''}
	
	# 4: /h/ to 0 (and unwritten rule of /ph/ -> f)
	change 4, {/ph/ => 'f', /h/ => ''}
	
	# 5: /e/ or /i/ in hiatus in unstressed penult to /j/ |I| (transcribed as |j|)
	change 5, {/[ei](#{V}#{C}*$)/ => 'j\1'}
	
	# 6: V in unstressed penult to 0
	#    use 'short' because otherwise it's not an unstressed penult
	change 6, {/#{SHORT}(#{C}?#{V}#{C}*$)/ => '\1'}, {/#{SHORT}(#{C}?#{V}#{C}*$)/ => '\1'}, { :only_if_phon => true }
		
	# 7: /tk/ to /tʃ/ |Z|
	change 7, {/t[ck]/ => 'tʃ'}, {/t[ck]/ => 'z'}
end

def change rule, pron_changes, orth_changes = pron_changes, options = {}
	hit_phon = pron_changes.keys.inject(nil) do |hit, key|
		hit_key = @pron.gsub! key, pron_changes[key]
		hit ||= hit_key
	end

	unless options[:only_if_phon] && !hit_phon
		hit_orth = orth_changes.keys.inject(nil) do |hit, key|
			hit_key = @orth.gsub! key, orth_changes[key]
			hit ||= hit_key
		end
	end

	print_change rule, @pron, @orth if hit_phon || hit_orth
end

def print_change rule, pron, orth
	puts rule.to_s.rjust(3) + " = " + pron.ljust(20) + orth
end

ibranify ARGV[0]
