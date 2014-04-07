#!/usr/bin/ruby
# encoding: UTF-8

GLYPH_DIR = 'glyphs'

# Maps a morpheme to its appropriate glyph
CONSONANT_MAP = {
  'p'=>'m',
  'b'=>'b',
  'g'=>'g',
  'd'=>'d',
  'ɖ'=>'ɖ',
  'l'=>'l',
  't'=>'l',
  'ɣ'=>'k',
  'k'=>'k',
  'ʈ'=>'ʈ',
  'ɭ'=>'ʈ'
}

# String containing all vowels
VOWELS = 'aioue'

# String containing all consonants
CONSONANTS = (CONSONANT_MAP.keys + CONSONANT_MAP.values).uniq.join

# Pulls morphemes (based on the CVC rule) from the given string
def morphemes str
  re = Regexp.new "([#{CONSONANTS}])([#{VOWELS}]+?)([#{CONSONANTS}])?"
  str.scan re
end


