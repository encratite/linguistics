require 'application/Language'

class Tibetan < Language
  #http://www.unicode.org/charts/PDF/U0F00.pdf

  #Radicals

  Ka = "\u0F40"
  Kha = "\u0F41"
  Ga = "\u0F42"
  Nga = "\u0F44"

  Ca = "\u0F45"
  Cha = "\u0F46"
  Ja = "\u0F47"
  Nya = "\u0F49"

  Ta = "\u0F4F"
  Tha = "\u0F50"
  Da = "\u0F51"
  Na = "\u0F53"

  Pa = "\u0F54"
  Pha = "\u0F55"
  Ba = "\u0F56"
  Ma = "\u0F58"

  Tsa = "\u0F59"
  Tsha = "\u0F5A"
  Dza = "\u0F5B"
  Wa = "\u0F5D"

  Zha = "\u0F5E"
  Za = "\u0F5F"
  Aa = "\u0F60"

  Ya = "\u0F61"
  Ra = "\u0F62"
  La = "\u0F63"

  Sha = "\u0F64"
  Sa = "\u0F66"
  Ha = "\u0F67"

  A = "\u0F68"

  KaSubscript = "\u0F90"

  #Not sure
  WaSubscript = "\u0FAD"

  HaSubscript = "\u0FB7"

  #Vowels

  VowelAa = "\u0F71"
  VowelI = "\u0F72"
  VowelIi = "\u0F73"
  VowelU = "\u0F74"
  VowelUu = "\u0F75"
  VowelE = "\u0F7A"
  VowelAi = "\u0F7B"
  VowelO = "\u0F7C"

  VowelAu = "\u0F7D"
  VowelRetroflexR = "\u0F76"
  VowelRetroflexRr = "\u0F77"
  VowelRetroflexL = "\u0F78"
  VowelRetroflexLl = "\u0F79"
  VowelNasalised1 = "\u0F7E"
  VowelNasalised2 = "\u0F83"
  VowelBreathy = "\u0F7F"

  Tseg = "\u0F0B"
  TsegBhstar = "\u0F0C"

  TerminationMark1 = "\u0F0D"
  TerminationMark2 = "\u0F0E"
  TerminationMark3 = "\u0F0F"

  Map = {
    Ka => ['k', :high],
    Kha => ['k_h', :high],
    #may also be aspirated
    Ga => ['k', :low],
    Nga => ['J', :low],

    Ca => ['tS', :high],
    Cha => ['tS_h', :high],
    Ja => ['tS', :low],
    Nya => ['J', :low],

    Ta => ['t', :high],
    Tha => ['t_h', :high],
    #may also be aspirated
    Da => ['t', :low],
    Na => ['n', :low],

    Pa => ['p', :high],
    Pha => ['p_h', :high],
    #may also be aspirated
    Ba => ['p', :low],
    Ma => ['m', :low],

    Tsa => ['ts', :high],
    Tsha => ['ts_h', :high],
    Dza => ['ts', :low],
    Wa => ['w', :low],

    Zha => ['S', :low],
    Za => ['s', :low],
    Aa => ['h', :low],

    Ya => ['j', :low],
    Ra => ['r', :low],
    La => ['l', :low],

    Sha => ['S', :high],
    Sa => ['s', :high],
    Ha => ['h', :low],

    #can also be a vowel carrier
    A => ['a', :high],

    #Subscript radicals

    KaSubscript => ['k', :high, :subscript],

    WaSubscript => ['w', :low, :subscript],

    HaSubscript => ['h', :low, :subscript],

    #Vowels

    VowelAa => ['a:', :vowel],
    VowelI => ['i', :vowel],
    VowelIi => ['i:', :vowel],
    VowelU => ['u', :vowel],
    VowelUu => ['u:', :vowel],
    VowelE => ['e', :vowel],
    VowelAi => ['ai', :vowel],
    VowelO => ['o', :vowel],

    VowelAu => ['au', :vowel],
    #Not sure about the retroflex ones
    VowelRetroflexR => 'r`',
    VowelRetroflexRr => 'r`:',
    VowelRetroflexL => 'l`',
    VowelRetroflexLl => 'l`:',
    VowelNasalised1 => '~',
    VowelNasalised2 => '~',
    VowelBreathy => '_t',

    Tseg => ' ',
    TsegBhstar => ' ',
    TerminationMark1 => ' ',
    TerminationMark2 => ' ',
    TerminationMark3 => ' ',
  }

  def transcribeWord(word)
    @output = []
    @word = word
    @wordUnicodeAnalysis = []
    @tone = nil
    @wasConsonant = false
    word.size.times do |index|
      @index = index
      letter = word[index]
      translation = Map[letter]
      if translation == nil
        raise LanguageError.new("Unknown Tibetan Unicode symbol #{letter.inspect}")
      end
      @wordUnicodeAnalysis << letterToUnicodeName(letter)
      puts translation.inspect
      case translation
      when Proc
        translation = translation.call
      when Symbol
        translation = method(translation).call
      when Array
        marker = translation[1]
        subscript = translation[2]
        translation = translation[0]
        if marker == :vowel
          if @tone != nil
            translation += getTone
          end
          @wasConsonant = false
          @tone = nil
        elsif marker == :low || marker == :high
          if subscript == nil
            vowelCheck
          end
          @tone = marker
          @wasConsonant = true
        else
          raise 'Invalid condition'
        end
      else
        vowelCheck
        @wasConsonant = false
      end
      puts @wasConsonant.inspect
      if translation != nil
        @output << translation
      end
    end
    output = fixOutput(@output.join(''))
    return output
  end

  def fixOutput(input)
    replacements = {
      '_L~' => '~_L',
      '_H~' => '~_H',
    }
    output = input
    replacements.each do |target, replacement|
      output = output.gsub(target, replacement)
    end
    return output
  end

  def vowelCheck
    if @wasConsonant
      @output << ('a' + getTone)
    end
  end

  def getTone
    if @tone == :high
      return '_H'
    elsif @tone == :low
      return '_L'
    else
      return ''
    end
  end

  def letterToUnicodeName(letter)
    Tibetan.constants.each do |symbol|
      value = Tibetan.const_get(symbol)
      if value == letter
        return symbol.to_s
      end
    end
    raise LanguageError.new("Unable to retrieve the Unicode name of #{letter.inspect}")
  end
end
