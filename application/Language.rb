class Language
  def transcribeWord(word)
    raise 'Function has not been implemented!'
  end

  def transcribe(lines)
    output = lines.map do |line|
      line.map do |word|
        transcribeWord(word)
      end
    end
  end
end
