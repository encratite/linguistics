require 'www-library/HTMLWriter'

require 'application/SiteContainer'
require 'application/XSAMPA'

class TranscriptionHandler < SiteContainer
  def renderTranscriptionForm
    writer = WWWLib::HTMLWriter.new
    writer.form(@submitTextHandler.getPath) do
      writer.p do
        options = @languages.map do |description, handler|
          WWWLib::SelectOption.new(description, description)
        end
        writer.select(Language, options)
      end
      writer.p do
        writer.textArea('Text', LanguageText) {}
      end
      writer.submit
    end
    return writer.output
  end

  def renderTranscription(lines)
    writer = WWWLib::HTMLWriter.new
    writeOutput = lambda do |description, mapping|
      writer.p(class: 'outputDescription') do
        "#{description}:"
      end
      writer.ul(class: 'output') do
        lines.each do |line|
          line = line.map do |word|
            mapping.call(word)
          end
          writer.li { line.join(' ') }
        end
      end
    end

    writeOutput.call('IPA output', XSAMPA.method(:toIPA))
    writeOutput.call('X-SAMPA output', lambda { |x| x })
    return writer.output
  end
end
