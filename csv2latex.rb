#!/usr/bin/ruby
# encoding: UTF-8

require 'csv'
require 'tmpdir'
require 'securerandom'

input, output = ARGV

chapter = nil
text = ''

CSV.foreach(File.path(input)) do |data|
  word, transcription, speech = data

  if(word == nil || transcription == nil || speech == nil)
    break
  end

  word.downcase!
  speech.downcase!

  if chapter != word[0]
    chapter = word[0]
    text += "\\chapter*{#{chapter.upcase}}\n"
  end

  text += "\\dict{#{word}}{#{speech}}{#{transcription}}\n"
end

texfile = Dir.tmpdir + File::SEPARATOR + SecureRandom.hex + '.tex'
texout = File.read("layout.tex").sub("%REPLACE_ME%", text)

File.write(texfile, texout)

`pdflatex --interaction nonstopmode -halt-on-error -file-line-error #{texfile} #{output}`
