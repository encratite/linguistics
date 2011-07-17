require 'application/Language'

class Arabic < Language
  AlifMadda = "\u0622"
  AlifHamzaAbove = "\u0623"
  WawHamza = "\u0624"
  AlifHamzaBelow = "\u0625"
  YaHamza = "\u0626"
  Alif = "\u0627"
  Baa = "\u0628"
  Marbuta = "\u0629"
  Taa = "\u062A"
  Ttaa = "\u062B"
  Giim = "\u062C"
  Hhaa = "\u062D"
  Khaa = "\u062E"
  Daal = "\u062F"

  Dhaal = "\u0630"
  Raa = "\u0631"
  Zayn = "\u0632"
  Siin = "\u0633"
  Shiin = "\u0634"
  Shaad = "\u0635"
  Dhaad = "\u0636"
  Thaa = "\u0637"
  Zaa = "\u0638"
  Ayn = "\u0639"
  Ghayn = "\u063A"
  #not sure
  KehehTwoDotsAbove = "\u063B"
  KehehThreeDotsBelow = "\u063C"
  #Farsi
  #Farsi
  #Farsi

  Tatwil = "\u0640"
  Faa = "\u0641"
  Qaaf = "\u0642"
  Kaaf = "\u0643"
  Laam = "\u0644"
  Miim = "\u0645"
  Nuun = "\u0646"
  Haa = "\u0647"
  Waaw = "\u0648"
  AlifMaqShuurah = "\u0649"
  Yaa = "\u064A"
  Fathatan = "\u064B"
  Dammatan = "\u064C"
  Kasratan = "\u064D"
  Fathah = "\u064E"
  Dammah = "\u064F"

  Kasrah = "\u0650"
  Shaddah = "\u0651"
  Sukuun = "\u0652"
  MaddahAbove = "\u0653"
  HamzaAbove = "\u0654"
  HamzaBelow = "\u0655"
  SubscriptAlif = "\u0656"
  InvertedDamma = "\u0657"
  NuunGhunna = "\u0658"
  Zwarakay = "\u0659"
  VowelSign = "\u065A"
  InvertedVowelSign = "\u065B"
  VowelSignBelow = "\u065C"
  ReversedDamma = "\u065D"
  FathahTwoDots = "\u065E"
  WavyHamzaBelow = "\u065F"

  Alifs = [
    AlifMadda,
    AlifHamzaAbove,
    AlifHamzaBelow,
    Alif,
  ]

  Map = {
    AlifMadda => :alifMadda,
    AlifHamzaAbove => '?',
    WawHamza => '?w',
    AlifHamzaBelow => :alifHamzaBelow,
    YaHamza => '?j',
    Alif => :alif, #uncertain
    Baa => 'b',
    Marbuta => 'a', #or at?
    Taa => 't',
    Ttaa => 'T',
    Giim => 'dZ', #dZ ~ Z ~ g
    Hhaa => 'X\\',
    Khaa => 'x',
    Daal => 'd',

    Dhaal => 'D',
    Raa => 'r',
    Zayn => 'z',
    Siin => 's',
    Shiin => 'S',
    Shaad => 's_?\\',
    Dhaad => 'd_?\\',
    Thaa => 't_?\\',
    Zaa => 'z_?\\', #D_?\ ~ z_?\
    Ayn => '?\\',
    Ghayn => 'G',

    Faa => 'f',
    Qaaf => 'q',
    Kaaf => 'k',
    Laam => 'l',
    Miim => 'm',
    Nuun => 'n',
    Haa => 'h',
    Waaw => 'w', #w, u:, aw, uncertain
    Yaa => 'j', #j, i: aj, uncertain

    Fathah => :fathah,
    Dammah => :dammah,
    Kasrah => :kasrah,
    Shaddah => :shaddah,
    Sukuun => '', #I think...
  }

  AdvancingConsonants = [
    'm',
    'b',
    'f',

    'T',
    'D',
    'n',
    't',
    'd',
    's',
    'z',
    'l',
  ]

  def transcribeWord(word)
    @output = []
    @skip = false
    @word = word
    @lastConsonant = nil
    @wordUnicodeAnalysis = []
    word.size.times do |index|
      @index = index
      if @skip
        @skip = false
        next
      end
      letter = word[index]
      translation = Map[letter]
      if translation == nil
        raise LanguageError.new("Unknown Arabic Unicode symbol #{letter.inspect} in word #{letter.inspect}")
      end
      @wordUnicodeAnalysis << letterToUnicodeName(letter)
      @isVowel = false
      case translation
      when Proc
        translation = translation.call
      when Symbol
        translation = method(translation).call
      end
      if !@isVowel
        @lastConsonant = translation
      end
      @wasVowel = @isVowel
      if translation != nil
        @output << translation
      end
    end
    output = @output.join('')
    output = fix(output)
    return output
  end

  def letterToUnicodeName(letter)
    Arabic.constants.each do |symbol|
      value = Arabic.const_get(symbol)
      if value == letter
        return symbol.to_s
      end
    end
    raise LanguageError.new("Unable to retrieve the Unicode name of #{letter.inspect}")
  end

  def fix(input)
    output = input.gsub('_?\a', 'A')
    AdvancingConsonants.each do |consonant|
      output = output.gsub("#{consonant}a", "#{consonant}{")
    end
    output = output.gsub('d', 'd_d')
    output = output.gsub('t', 't_d')
    return output
  end

  def nextLetter
    nextLetter = nil
    nextIndex = @index + 1
    if nextIndex < @word.size
      nextLetter = @word[nextIndex]
    end
    return nextLetter
  end

  def lastConsonant
    if @lastConsonant == nil
      raise LanguageError.new("Unable to retrieve the last letter of an empty word")
    end
    return @lastConsonant
  end

  def skip
    @skip = true
  end

  def alifMadda
    @isVowel = true
    return '?a:'
  end

  def alifHamzaBelow
    @isVowel = true
    return '?i'
  end

  def isAlif(letter)
    return Alifs.include?(letter)
  end

  def alif
    @isVowel = true
    if @output.empty?
      return nil
    end
    return 'a:'
  end

  def fathah
    @isVowel = true
    if isAlif(nextLetter)
      skip
      return 'a:'
    else
      return 'a'
    end
  end

  def dammah
    @isVowel = true
    if nextLetter == Waaw
      skip
      return 'u:'
    else
      return 'u'
    end
  end

  def kasrah
    @isVowel = true
    if nextLetter == Yaa
      skip
      return 'i:'
    else
      return 'i'
    end
  end

  def shaddah
    if @wasVowel
      output = @output[-1]
      @output = @output[0..-2]
      @output << lastConsonant
    else
      output = lastConsonant
    end
    return output
  end
end
