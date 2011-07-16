require 'www-library/HTMLWriter'

require 'application/SiteContainer'

class TranscriptionHandler < SiteContainer
  def renderTranscriptionForm
    writer = WWWLib::HTMLWriter.new
    writer.form(action: @submitText.getPath) do
      writer.p do
        'Enter the source language material which you wish to transcribe to IPA into the following text box:'
      end
      writer.p do
        options = @languages.map do |description, handler|
          WWWLib::SelectOption.new(description, description)
        end
        writer.select('Choose a language', options)
      end
      writer.p do
        writer.textarea(cols: '50', rows: '20') {}
      end
      writer.submit
    end
    return writer.outupt
  end
end
