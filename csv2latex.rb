#!/usr/bin/ruby
# encoding: UTF-8

require 'csv'
require 'tmpdir'
require 'securerandom'
require './transcriber'

input, output = ARGV

chapter = '0-9'
text = ''

MAP = {
    'ɖ'=>'\:d',
    'ɣ'=>'G',
    'ʈ'=>'\:t',
    'ɭ'=>'\:l'
}

images = []

#text = File.read(input).gsub(/\\"/,'""')
CSV.foreach(input) do |data|
  word, transcription, speech = data

  if(word == nil || transcription == nil || speech == nil)
    next
  end

  word.downcase!
  word.strip!

  transcription.downcase!
  transcription.strip!

  speech.downcase!
  speech.strip!

  if chapter != word[0] && word[0] >= 'a'
    chapter = word[0]
    #text += "\\chapter*{#{chapter.upcase}}\n"
  end

  ipa = ''

  transcription.each_char do|i|
    if MAP[i] != nil
      ipa += MAP[i]
    else
      ipa += i
    end
  end
  texfile = Dir.tmpdir + File::SEPARATOR + SecureRandom.hex + '.tex'
  
  text += "\\begin{minipage}{\\textwidth}\n"
  text += "\\dict{#{word}}{#{speech}}{#{ipa}}\n"

  imgfile = 'tmp' + File::SEPARATOR + SecureRandom.hex + '.png'
  
  if Transcriber.transcribe(transcription, imgfile)
    text += "\\newline\n"
    text += "\\begingroup\n"
    text += "   \\centering\n"
    text += "   \\includegraphics[height=0.7cm,width=\\linewidth,keepaspectratio]{#{imgfile}}\n"
    text += "\\endgroup\n"
    images.push imgfile
  end
  text += "\\end{minipage}\n"
end

texfile = Dir.tmpdir + File::SEPARATOR + SecureRandom.hex + '.tex'
texout = File.read("layout.tex").sub("%REPLACE_ME%", text)

File.write(texfile, texout)

`pdflatex --jobname=#{output} --interaction nonstopmode -halt-on-error -file-line-error #{texfile}`

images.each{|img|
  File.delete img
}
