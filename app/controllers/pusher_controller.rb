class PusherController < ApplicationController
  def auth
    response = Pusher[params[:channel_name]].authenticate params[:socket_id]
    render(
      text: params[:callback] + "(" + response.to_json + ")",
      content_type: 'application/javascript'
    )
  end

  def current_session
    Session.find_by token: params[:token]
  end
end
