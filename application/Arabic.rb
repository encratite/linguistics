# -*- coding: utf-8 -*-
require 'application/Language'

class Arabic < Language
  Map = {
    'أ' => 'ʔ',
  }

  def transcribeWord(word)
    output = ''
    word.each_char do |char|
      translation = Map[char]
      if translation == nil
        raise "Unknown Arabic Unicode symbol #{char.inspect} in word #{word.inspect}"
      end
      output += translation
    end
    return output
  end
end
