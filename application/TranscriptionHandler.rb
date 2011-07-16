require 'nil/string'

require 'www-library/RequestHandler'

require 'application/SiteContainer'
require 'application/error'

require 'visual/TranscriptionHandler'

class TranscriptionHandler < SiteContainer
  Arabic = 'Arabic'

  Language = 'language'
  LanguageText = 'text'

  def installHandlers
    transcriptionForm = WWWLib::RequestHandler.handler('transcriptionForm', method(:transcriptionForm))
    addHandler(transcriptionForm)
    @submitTextHandler = WWWLib::RequestHandler.handler('submitText', method(:submitText))
    addHandler(@submitTextHandler)
    @languages = [
      [Arabic, method(:transcribeArabic)],
    ]
  end

  def transcriptionForm(request)
    title = 'Transcribe to IPA'
    return @generator.get(renderTranscriptionForm, request, title)
  end

  def submitText(request)
    language = request.getPost(Language)
    languageText = request.getPost(LanguageText)
    if language == nil || languageText == nil
      argumentError
    end
    @languages.each do |description, handler|
      if language == description
        inputLines = languageText.split("\n")
        inputLines.map! do |line|
          line.split
        end
        outputLines = handler.call(inputLines)
        content = renderTranscription(outputLines)
        title = 'Transcription result'
        return @generator.get(content, request, title)
      end
    end
    argumentError
  end

  def transcribeArabic(words)
  end
end
