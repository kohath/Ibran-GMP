#!/usr/bin/env ruby

SHORT = '[aeiouy]'
LONG = '[aeiouyæœå]:'
V = '[aeiouyæœå]:?'
C = '[bcdfghklmnpqrsʃtvxz]'
L = '[lr]'
HEAVY_PENULT = "#{C}{2,}#{V}#{C}*$"
LONG_PENULT = ":#{C}?#{V}#{C}*$"
MONOSYLLABLE = "^#{C}*#{V}#{C}*$"
DISYLLABLE = "^#{C}*#{V}#{C}*#{V}#{C}*$"
ANTEPENULT = "#{C}*#{V}#{C}*#{V}#{C}*$"

def ibranify latin
	@pron, @orth = latin.dup, latin.dup

	# Derive orthography from input
	change 0, {/x/ => 'ks', 
						 /ae/ => 'æ:',
						 /oe/ => 'œ:',
						 /au/ => 'å:',
						 /c/ => 'k', 
						 /qu/ => 'q', 
						 /(#{C}?#{L}?#{V}#{HEAVY_PENULT})/ => 'ˈ\1',
						 /(#{C}?#{L}?#{SHORT}#{LONG_PENULT})/ => 'ˈ\1',
						 /(#{MONOSYLLABLE})/ => 'ˈ\1',
						 /(#{DISYLLABLE})/ => 'ˈ\1',
						 /(#{C}?#{L}?#{V}#{ANTEPENULT})/ => 'ˈ\1',
						 /q/ => 'kʷ', }, 
		{ /qu/ => 'q', 
						 /(#{C}?#{L}?#{V})(#{HEAVY_PENULT})/ => '\1́\2',
						 /(#{C}?#{L}?#{SHORT})(#{LONG_PENULT})/ => '\1́\2',
						 /(^#{C}*#{V})(#{C}*$)/ => '\1́\2',
						 /(^#{C}*#{V})(#{C}*#{V}#{C}*$)/ => '\1́\2',
						 /(#{C}?#{L}?#{V})(#{ANTEPENULT})/ => '\1́\2',
						 /q/ => 'qu',
						 /ae/ => 'æ',
						 /oe/ => 'œ',
						 /au/ => 'å',
						 /:/ => ""}

	# 1: Word-final /m/ -> 0
	change 1, {/m$/ => ''}
	
	# 2: /mn/ -> /nn/
	change 2, {/m(ˈ?)n/ => 'n\1n'}
	
	# 3: Word-final /t/ -> 0
	change 3, {/t$/ => ''}
	
	# 4: /h/ to 0 (and unwritten rule of /ph/ -> f)
	change 4, {/p(ˈ?)h/ => '\1f', /(#{C}?)(ˈ?)h/ => '\2\1'}
	
	# 5: /e/ or /i/ in hiatus in unstressed penult to /j/ |I| (transcribed as |j|)
	change 5, {/[ei](#{V}#{C}*$)/ => 'j\1'}
	
	# 6: V in unstressed penult to 0
	#    use 'short' because otherwise it's not an unstressed penult
	change 6, {/(#{V}.*)#{SHORT}(#{C}?#{V}#{C}*$)/ => '\1\2'}, {/(#{V}.*)#{SHORT}(#{C}?#{V}#{C}*$)/ => '\1\2'}, { :only_if_phon => true }
		
	# 7: /tk/ to /tʃ/ |Z|
	change 7, {/t(ˈ?)[ck]/ => '\1tʃ'}, {/t[ck]/ => 'z'}
	
	# 8: Stressed vowel changes
	# Broken into long and short for ambiguity in orth, but both are rule 8 (only one gets called)
		# SHORT vowels
	change 8, {/(ˈ#{C}*)a([^:]|$)/ => '\1ɑ\2',
							 /(ˈ#{C}*)e([^:]|$)/ => '\1ɛ\2',
							 /(ˈ#{C}*)i([^:]|$)/ => '\1e\2',
							 /(ˈ#{C}*)o([^:]|$)/ => '\1ɔ\2',
							 /(ˈ#{C}*)u([^:]|$)/ => '\1o\2'}, 
		{ /é/ => 'ę́', 
		  /í/ => 'ẹ́',
		  /ó/ => 'ǫ́',
		  /ú/ => 'ọ́'}, { :only_if_phon => true }
		# LONG vowels
	change 8, {/(ˈ#{C}*)a:/ => '\1ɑ',
						 /(ˈ#{C}*)(æ:)/ => '\1ɛ',
						 /(ˈ#{C}*)(e:|œ:)/ => '\1e',
						 /(ˈ#{C}*)i:/ => '\1i',
						 /(ˈ#{C}*)(o:|å:)/ => '\1o',
						 /(ˈ#{C}*)u:/ => '\1u'},
		{ /ǽ/ => 'ę́',
			/é|œ́/ => 'ẹ́',
			/ó|ǻ/ => 'ọ́'
		}

	# unstressed vowels
	change 9, {/a/ => 'ɑ', /(œ:|æ:)/ => 'ɛ', /å:/ => 'ɔ'}, {/(œ|æ)/ => 'e', /å/ => 'o'}
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
