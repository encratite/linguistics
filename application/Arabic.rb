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
  Thaa = "\u062B"
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
  AlifMaqShuurah= "\u0649"
  Yaa = "\u064A"
  Fathatan = "\u064B"
  Dammatan = "\u064C"
  Kasratan = "\u064D"
  Fathah = "\u064E"
  Damma = "\u064F"

  Kasra = "\u0650"
  Shadda = "\u0651"
  Sukun = "\u0652"
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
    AlifMadda => '?a:',
    AlifHamzaAbove => '?',
    WawHamza => '?w',
    AlifHamzaBelow => '?i',
    YaHamza => '?j',
    Alif => '',
    

    Fathah => method(:fathah),
  }

  def transcribeWord(word)
    output = ''
    word.size.times do |index|
      letter = word[index]
      translation = Map[letter]
      if translation == nil
        raise "Unknown Arabic Unicode symbol #{char.inspect} in word #{word.inspect}"
      end
      if translation.class == Method
        nextLetter = nil
        nextIndex = index + 1
        if nextIndex < word.size
          nextLetter = word[index]
        end
        translation = translation.call(nextLetter)
      end
      output += translation
    end
    return output
  end

  def isAlif(letter)
    return Alifs.include?(letter)
  end

  def fathah(nextLetter)
    return isAlif(nextLetter) ? 'a:' : 'a'
  end
end
