class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    respond_with User.includes(:identities).all, status: 200
  end

  def show
    respond_with User.find(params[:id])
  end
end
