require 'nil/string'

require 'www-library/RequestHandler'

require 'application/Arabic'
require 'application/error'
require 'application/SiteContainer'

require 'visual/TranscriptionHandler'

class TranscriptionHandler < SiteContainer
  Language = 'language'
  LanguageText = 'text'

  def installHandlers
    transcriptionForm = WWWLib::RequestHandler.handler('transcriptionForm', method(:transcriptionForm))
    addHandler(transcriptionForm)
    @submitTextHandler = WWWLib::RequestHandler.handler('submitText', method(:submitText))
    addHandler(@submitTextHandler)
    @languages = [
      ['Arabic', Arabic],
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
    @languages.each do |description, languageClass|
      if language == description
        inputLines = languageText.split("\n")
        inputLines.map! do |line|
          line.split(' ')
        end
        translator = languageClass.new
        begin
          outputLines = translator.transcribe(inputLines)
          content = renderTranscription(translator, outputLines)
          title = "#{description} transcription result"
          return @generator.get(content, request, title)
        rescue LanguageError => exception
          plainError(exception.message)
        end
      end
    end
    argumentError
  end
end
