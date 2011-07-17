class Language
  attr_reader :unicodeNames

  def initialize
    @unicodeNames = nil
  end

  def transcribeWord(word)
    raise 'Function has not been implemented!'
  end

  def transcribe(lines)
    unicodeNames = []
    output = lines.map do |line|
      line.map do |word|
        output = transcribeWord(word)
        if @wordUnicodeAnalysis != nil
          unicodeNames << @wordUnicodeAnalysis
        end
        output
      end
    end
    if !unicodeNames.empty?
      @unicodeNames = unicodeNames
    end
    return output
  end
end
