Transcriber
====================

This was a project to assist in an introductory linguistics class at Brigham    
Young University. This module takes a string of phonemes from a predefined      
inventory and transcribes them in our invented orthography.

USAGE
-------------------

To write the word _bibkuppaɣgog_ into an image file named `tmp2.png`

```ruby
include Transcriber

glyph = nil                                                                     
morphemes('bibkuppaɣgog').each{|morpheme|                                       
  glyph = make_char_glyph(morpheme, glyph)                                      
}                                                                               
glyph.write 'tmp2.png'
```

EXAMPLES
-------------------
bibkuppaɣgog
![bibkuppaɣgog](../blob/master/examples/bibkuppaɣgog.png?raw=true)

ʈioɖugtak
![ʈioɖugtak](../blob/master/examples/ʈioɖugtak.png?raw=true)

kopdakab
![kopdakab](../blob/master/examples/kopdakab.png?raw=true)

libpaplobut
![libpaplobut](../blob/master/examples/libpaplobut.png?raw=true)
