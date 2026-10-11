class ConversationsController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_path
  end
end
