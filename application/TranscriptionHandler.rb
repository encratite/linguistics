require 'nil/string'

require 'www-library/RequestHandler'

require 'application/SiteContainer'
require 'application/error'

require 'visual/TranscriptionHandler'

class TranscriptionHandler < SiteContainer
  Arabic = 'Arabic'

  def installHandlers
    transcriptionForm = WWWLib::RequestHandler.handler('TranscriptionForm', method(:transcriptionForm))
    addHandler(transcriptionForm)
    @submitText = WWWLib::RequestHandler.handler('SubmitText', method(:submitText))
    addHandler(@submitText)
    @languages = [
      [Arabic, method(:transcribeArabic)],
    ]
  end

  def transcriptionForm
    title = 'Transcribe to IPA'
    return @generator.get(renderTranscriptionForm, request, title)
  end

  def submitText
    content = 'Blah'
    title = 'Transcription result'
    return @generator.get(content, request, title)
  end
end
