class MessagesController < ApplicationController
  def index
  end

  def create
    # params = "message"=>{"content"=>"Hello!"}, "controller"=>"messages", "action"=>"create", "criteria_id"=>"1", "conversation_id"=>"1"} permitted: false>

    @conversation = Conversation.find(params[:conversation_id])
    # @criteria = Criteria.find(params[:criteria_id])

    @message = Message.new(message_params)

    @message.sender = "user"
    @message.conversation = @conversation
    # @message.criteria = @criteria

    if @message.save
      redirect_to conversation_path(@conversation)

      @messageAI = Message.new
      @messageAI.sender = "AI"
      @messageAI.content = "here is Chaplin's response"
      @messageAI.conversation = @conversation
      @messageAI.save
    else
      render :show, status: :unprocessable_entity # There is not "new" here, so we use show
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
