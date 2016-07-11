class MessagesController < ApplicationController
  def index
    @messages = Message.between current_user.id, params[:user_id]
    render json: @messages, status: 200
  end
end
