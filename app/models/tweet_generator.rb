require 'marky_markov'

class TweetGenerator
  def self.generate( query )
    return "Please provide a keyword." if query == nil || query.empty?

    search_results = TwitterProxy.search( query )

    if search_results.nil? ||  search_results.empty?
      return "Sorry, but something has failed."
    elsif search_results[:error]
      return "Sorry, there was an error: " + search_results[:error]
    elsif search_results[:results].size < 10
      return "Sorry, but I cannot find enough information about that word."
    else
      paragraph = search_results[:results].map{ |elem| elem['text'] }.join(".\n")

      mm = MarkyMarkov::TemporaryDictionary.new(1)
      mm.parse_string( paragraph )

      return mm.generate_n_sentences(2)
    end
  end
end