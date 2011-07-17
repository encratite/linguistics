# -*- coding: utf-8 -*-
require 'application/Language'

class Chinese < Language
  Initials = {
    'zh' => 'ts`',
    'ch' => 'ts`_h',
    'sh' => 's`',
    'b' => 'p',
    'p' => 'p_h',
    'm' => 'm',
    'f' => 'f',
    'd' => 't',
    't' => 't_h',
    'n' => 'n',
    'l' => 'l',
    'g' => 'k',
    'k' => 'k_h',
    'h' => 'x',
    'j' => 'ts\\',
    'q' => 'ts\\_h',
    'x' => 's\\',
    'z' => 'ts',
    'c' => 'ts_h',
    's' => 's',
    'w' => 'w',
    'y' => 'j', #requires fixing
  }

  Finals = {
    #skipped -i
    'a' => 'A',
    'e' => 'MV', #@ when unstressed
    'ai' => 'aI',
    'ei' => 'eI',
    'ao' => 'AU',
    'ou' => '7U',
    'an' => 'an',
    'en' => '@n',
    'ang' => 'AN',
    'eng' => '@N',
    #skipped er

    'i' => 'i',
    'ia' => 'iA',
    'ie' => 'iE',
    'iao' => 'iAU',
    'iu' => 'i7U',
    'ian' => 'iEn',
    'in' => 'in',
    'iang' => 'iAN',
    'ing' => 'iN',

    'u' => 'u',
    'ua' => 'uA',
    'uo' => 'uO',
    'o' => 'uO',
    'uai' => 'uaI',
    'ui' => 'ueI',
    'uan' => 'uan',
    'un' => 'u@n',
    'uang' => 'uAN',
    'ong' => 'UN', #also u@N

    'u' => 'y',
    'ue' => 'y9',
    'uan' => 'yEn',
    'un' => 'yn',
    'iong' => 'iUN',
  }

  Accents = [
    'āáǎàa',
    'ēéěèe',
    'īíǐìi',
    'ōóǒòo',
    'ūúǔùu',
  ]

  Tones = [
    '_T',
    '_H_T',
    '_F_H', #this is wrong
    '_F',
  ]

  #remove accents and determine tone
  def processFinal(final)
    output = ''
    tone = nil
    final.each_char do |letter|
      hit = false
      Accents.each do |accentString|
        index = accentString.index(letter)
        if index != nil
          output += accentString[-1]
          hit = true
          if index >= 0 && index <= 3
            if tone != nil
              raise LanguageError.new("Encountered two tones in the final #{final.inspect}")
            end
            tone = Tones[index]
          end
          break
        end
      end
      if false
        raise LanguageError.new("Unable to process the final #{final.inspect}")
      end
    end
    return output, tone
  end

  def transcribeWord(word)
    word = word.downcase
    Initials.each do |initial, initialXSAMPA|
      if word[0..initial.size - 1] == initial
        rest = word[initial.size..-1]
        final, tone = processFinal(rest)
        finalXSAMPA = Finals[final]
        output = initialXSAMPA + finalXSAMPA
        if tone != nil
          #output += tone
        end
        return output
      end
    end
    raise LanguageError.new("Unable to translate the initial in #{word.inspect}")
  end
end
