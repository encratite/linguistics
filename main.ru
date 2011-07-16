$:.concat ['.', '..']

require 'application/LinguisticsSite'
require 'application/TranscriptionHandler'

linguisticsSite = LinguisticsSite.new
TranscriptionHandler.new(linguisticsSite)

handler = lambda do |environment|
  linguisticsSite.requestManager.handleRequest(environment)
end

run(handler)
