require 'www-library/SiteGenerator'
require 'www-library/HTMLWriter'
require 'www-library/string'

class LinguisticsSiteGenerator < WWWLib::SiteGenerator
  def render(request, content)
    writer = WWWLib::HTMLWriter.new
    writer.div(class: 'container') do
      writer.div do
        writer.img(id: 'ipa', src: 'http://upload.wikimedia.org/wikipedia/commons/9/9f/IPA_in_IPA.svg', alt: 'International Phonetic Alphabet')
      end
      writer.write(content)
    end
    return writer.output
  end
end
