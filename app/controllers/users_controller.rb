class UsersController < ApplicationController
  def index
    respond_with User.all, status: 200
  end
end
