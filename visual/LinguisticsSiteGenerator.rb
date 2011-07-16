require 'www-library/SiteGenerator'
require 'www-library/HTMLWriter'
require 'www-library/string'

class LinguisticsSiteGenerator < WWWLib::SiteGenerator
  def render(request, content)
    writer = WWWLib::HTMLWriter.new
    writer.write(content)
    return writer.output
  end
end
