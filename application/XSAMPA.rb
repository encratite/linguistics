require 'nil/file'

module XSAMPA
  def self.loadData
    lines = Nil.readLines('data/X-SAMPA')
    output = []
    lines.each do |line|
      tokens = line.split(' ')
      if tokens.size != 2
        raise "Invalid X-SAMPA entry: #{line.inspect}"
      end
      xsampa, ipa = tokens
      output << [xsampa, ipa]
    end
    output.sort! do |x, y|
      - (x.first.size <=> y.first.size)
    end
    return output
  end

  def self.toIPA(input)
    output = input
    IPAMap.each do |xsampa, ipa|
      output = output.gsub(xsampa, ipa)
    end
    return output
  end

  IPAMap = XSAMPA.loadData
end
