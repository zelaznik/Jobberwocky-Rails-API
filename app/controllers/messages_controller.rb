class MessagesController < ApplicationController
  def index
    @messages = model.between(current_user.id, params[:user_id])
    render json: @messages, status: 200
  end

  def create
    begin
      @message = Message.create! sender: current_user, receiver_id: params[:user_id], body: params[:body]
      Pusher.trigger "private-#{params[:user_id]}", 'NEW_MESSAGE', MessageSerializer.parse(@message)
      render json: @message, status: 200
    rescue Exception => e
      render json: {error: e.to_s}, status: 500
    end
  end

  private
  def model
    Message.includes sender: [:identities]
  end
end
