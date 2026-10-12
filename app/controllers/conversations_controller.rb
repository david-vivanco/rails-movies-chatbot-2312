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
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_path
  end
end
