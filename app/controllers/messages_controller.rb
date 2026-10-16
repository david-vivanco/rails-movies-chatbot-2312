class MessagesController < ApplicationController
  def index
  end

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.new(message_params)
    @message.sender = "user"

    if @message.save
      # Appel de notre service IA : il génère la recommandation et crée le message assistant en DB
      # MovieAdvisorService.new(@conversation).call

      redirect_to conversation_path(@conversation)
    else
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
