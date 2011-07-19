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
    'r' => 'z`', #not sure
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

  Fixed = {
    'er' => 'Ar\\`',
    'yu' => 'jy',
    'zi' => 'ts1',
    'ci' => 'ts_1',
    'si' => 's1',
    'zhi' => 'ts`1',
    'chi' => 'ts`_h1',
    'shi' => 's`1',
    'ri' => '1',
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
    '_M_T',
    '_L_B_H',
    '_T_B',
  ]

  def translateVowel(vowel)
    Accents.each do |vowelString|
      offset = vowelString.index(vowel)
      if offset == nil
        next
      end
      if offset == 4
        return nil
      end
      withoutAccent = vowelString[-1]
      return withoutAccent, Tones[offset]
    end
    return nil
  end

  def accentTranslation(string)
    tone = nil
    output = ''
    string.each_char do |letter|
      translationData = translateVowel(letter)
      if translationData == nil
        output += letter
      else
        if tone != nil
          raise LanguageError.new("Encountered two tones in #{string.inspect}, first one was #{tone.inspect}")
        end
        withoutAccent, tone = translationData
        output += withoutAccent
      end
    end
    return output, tone
  end

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
              raise LanguageError.new("Encountered two tones in #{final.inspect}")
            end
            tone = Tones[index]
          end
          break
        end
      end
      if !hit
        output += letter
      end
    end
    return output, tone
  end

  def transcribeWord(word)
    word = word.downcase
    translatedWord, tone = accentTranslation(word)
    fixed = Fixed[translatedWord]
    if fixed != nil
      return fixed + tone
    end
    Initials.each do |initial, initialXSAMPA|
      if word[0..initial.size - 1] == initial
        rest = word[initial.size..-1]
        final, tone = processFinal(rest)
        finalXSAMPA = Finals[final]
        output = initialXSAMPA + finalXSAMPA
        if tone != nil
          output += tone
        end
        return output
      end
    end
    raise LanguageError.new("Unable to translate the initial in #{word.inspect}")
  end
end
