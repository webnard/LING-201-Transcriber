#!/usr/bin/ruby
# encoding: UTF-8

require 'csv'
require 'tmpdir'
require 'securerandom'

input, output = ARGV

chapter = '0-9'
text = ''

MAP = {
    'ɖ'=>'\:d',
    'ɣ'=>'G',
    'ʈ'=>'\:t',
    'ɭ'=>'\:l'
}

text = File.read(input).gsub(/\\"/,'""')
CSV.parse(text) do |data|
  word, transcription, speech = data

  if(word == nil || transcription == nil || speech == nil)
    next
  end

  word.downcase!
  speech.downcase!

  if chapter != word[0] && word[0] >= 'a'
    chapter = word[0]
    text += "\\chapter*{#{chapter.upcase}}\n"
  end

  ipa = ''

  transcription.each_char do|i|
    if MAP[i] != nil
      ipa += MAP[i]
    else
      ipa += i
    end
  end

  text += "\\dict{#{word}}{#{speech}}{#{ipa}}\n"
end

texfile = Dir.tmpdir + File::SEPARATOR + SecureRandom.hex + '.tex'
texout = File.read("layout.tex").sub("%REPLACE_ME%", text)

File.write(texfile, texout)

`pdflatex --interaction nonstopmode -halt-on-error -file-line-error #{texfile} #{output}`
