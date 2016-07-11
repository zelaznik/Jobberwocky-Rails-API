class MessagesController < ApplicationController
  def index
    respond_with Message.between(current_user.id, params[:user_id])
  end
end
