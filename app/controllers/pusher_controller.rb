class PusherController < ApplicationController
  def auth
    auth = Pusher[params[:channel_name]].authenticate params[:socket_id]
    response = params[:callback] + "(" + auth.to_json + ")"

    if params[:channel_name] == "private-#{current_user.id}"
      render text: response, content_type: 'application/javascript'
    else
      render text: "Not Authorized", status: 403
    end
  end

  def current_session
    @current_session ||= Session.joins(user: [:identities]).find_by token: params[:token]
  end
end
