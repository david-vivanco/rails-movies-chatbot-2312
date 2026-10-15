class TmdbSearchService
  include HTTParty

  BASE_URL = "https://api.themoviedb.org/3"

  def initialize(title, year = nil)
    @title = title
    @year = year
  end

  def call
    response = self.class.get(
      "#{BASE_URL}/search/movie",
      headers: {
        "Authorization" => "Bearer #{ENV['TMDB_API_KEY']}",
        "accept" => "application/json"
      },
      query: {
        query: @title,
        year: @year,
        language: "fr-FR"
      }
    )

    response.parsed_response["results"]&.first
  end
end
