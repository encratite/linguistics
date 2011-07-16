require 'visual/LinguisticsSiteGenerator'

require 'www-library/SiteGenerator'

class LinguisticsSiteGenerator < WWWLib::SiteGenerator
  Name = 'Linguistics'

  def initialize(site, manager)
    super(manager)
    @site = site
  end

  def get(content, request, title)
    content = render(request, content)
    fullTitle = "#{title} - #{Name}"
    super(fullTitle, content)
  end
end
