#!/usr/bin/ruby
# encoding: UTF-8

require 'mini_magick'
include MiniMagick

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

# Creates a glyph for the given morpheme.
# Returns an instance of Image
def make_char_glyph morpheme
  consonant = morpheme[0]
  vowels = morpheme[1].split('')
  consonant2 = morpheme[2]

  dir = GLYPH_DIR + File::SEPARATOR

  cimg = Image.open(dir + consonant + '.png', 'png')
  v1img = Image.open(dir + vowels[0] + '.png', 'png')
  v2img = nil
  c2img = nil
  
  image = cimg.composite(v1img)
  return image

  if(vowels[1] != nil)
    v2img = dir + vowels[1] + '.png'
    # cut me in two
    #w = v2img.x_size
    #h = v2img.y_size
    #v2img = v2img.extract_area(w/2, h/2, w, h)

    image.read(v2img)
  end
  
  if consonant2 != nil
    #c2img = Image.new(dir + consonant2 + '.png').flipver()
    image.read c2img
  end
  image.mosaic
end
