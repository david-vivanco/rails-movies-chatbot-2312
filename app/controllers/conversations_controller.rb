class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations.order(created_at: :desc)
  end

  def create
    @criteria = Criteria.find(params[:criteria_id])
    @conversation = Conversation.new(
      criteria: @criteria,
      user: current_user,
      # title: "Conversation du #{Time.current.strftime('%d/%m/%Y %H:%M')}"
      title: "Pas de film selectionné"
    )
    if @conversation.save
      redirect_to conversation_path(@conversation)
    else
      render "criterias/show", status: :unprocessable_entity
    end
  end

  def show
    @conversation = current_user.conversations.find(params[:id])
    @criteria = Criteria.find(@conversation.criteria_id)
    @message = Message.new(sender: "user", conversation_id: params[:id])
    cards = MovieAdvisorService.new(@conversation).call

    @movies = cards["movies"].map do |movie|
      tmdb_movie = TmdbSearchService.new(
        movie["title"],
        movie["year"]
      ).call

      Rails.logger.debug "Recherche TMDB : #{movie['title']} => #{tmdb_movie.present?}"
      # We temporarily rename the conversation with last proposed film (until user selects one)
      # @conversation.title = "Dernière recommendation: #{movie["title"]}"
      # @conversation.save
      # string = "Dernière recommandation : #{movie['title']}"
      # @conversation.update(title: "Dernière recommandation: #{movie['title']}")

      next unless tmdb_movie

      {
        title: tmdb_movie["title"],
        poster_url: "https://image.tmdb.org/t/p/w500#{tmdb_movie['backdrop_path']}",
        overview: tmdb_movie["overview"],
        rating: tmdb_movie["vote_average"].round(1)
      }
    end.compact

    # Renomme avec le dernier film recommandé, sauf si un film a déjà été choisi
    return unless @movies.any? && !@conversation.title.start_with?("🎬")

    @conversation.update(title: "Dernière recommandation : #{@movies.last[:title]}")
  end

  def close
    @conversation = current_user.conversations.find(params[:id])

    if params[:selected_movie].present?
      @conversation.update(
        title: "🎬 #{params[:selected_movie]}"
      )
    end

    redirect_to conversations_path,
                notice: "Conversation clôturée"
  end

  def destroy
    @conversation = current_user.conversations.find(params[:id])
    @conversation.destroy
    redirect_to conversations_path, notice: "Recherche supprimée"
  end
end
