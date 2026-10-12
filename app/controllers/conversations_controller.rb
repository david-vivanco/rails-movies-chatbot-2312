class ConversationsController < ApplicationController
  def index
  end

  def create
    @criteria = Criteria.find(params[:criteria_id])
    @conversation = Conversation.new(
      criteria: @criteria,
      user: current_user,
      title: "Conversation du #{Time.current.strftime('%d/%m/%Y %H:%M')}"
     )
    if @conversation.save
      redirect_to conversation_path(@conversation)
    else
      render "criterias/show", status: :unprocessable_entity
    end
  end

  def show
    @criteria = Criteria.find(params[:id])
    @conversation = Conversation.find(params[:id])
    @message = Message.new(sender: "user", conversation_id: params[:id])

    movie1 = {
      title: "Singin' in the Rain",
      poster_url: "https://image.tmdb.org/t/p/w500/6qOyw4yfzbzTp5YsCX26C28Do0S.jpg",
      overview: "In 1927 Hollywood, a silent film star falls for a chorus girl just as he and his paranoid screen partner struggle to make the difficult transition to talking pictures.",
      rating: 8.1
    }

    movie2 = {
      title: "La Dolce Vita",
      poster_url: "https://image.tmdb.org/t/p/w500/eN2NdMeJLNzLYzWIEEoaGzZAsiD.jpg",
      overview: "Episodic journey of journalist Marcello who struggles to find his place in the world, torn between the allure of Rome's elite social scene and the stifling domesticity offered by his girlfriend, all the while searching for a way to become a serious writer.",
      rating: 8.0
    }

    movie3 = {
      title: "Vertigo",
      poster_url: "https://image.tmdb.org/t/p/w500/rtVwkTqllcmyY4TVOycgVBHppWf.jpg",
      overview: "A retired San Francisco detective suffering from acrophobia investigates the strange activities of an old friend's wife, all the while becoming dangerously obsessed with her.",
      rating: 8.1
    }

    movie4 = {
      title: "Citizen Kane",
      poster_url: "https://image.tmdb.org/t/p/w500/ruF3Lmd4A8MHbnEBE6lxPMbsHGL.jpg",
      overview: "Newspaper magnate Charles Foster Kane is taken from his mother as a boy and made the ward of a rich industrialist. As a result, every well-meaning, tyrannical or self-destructive move he makes for the rest of his life appears in some way to be a reaction to that deeply wounding event.",
      rating: 8.0
    }

    @movies = [movie1, movie2, movie3, movie4]
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_path
  end
end
