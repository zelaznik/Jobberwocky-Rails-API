module AuthHelper
  def current_user
    @current_user ||= User.find_by auth_token: request.headers['Authorization']
  end

  def authenticate_request
    puts "headers: #{request.headers}"
    if current_user.nil?
      render json: 'authentication failed', status: 401
    end
  end
end
