class Session < ActiveRecord::Base
  belongs_to :user, inverse_of: :sessions
  validates_presence_of :user

  def is_valid?
    expire_date.nil? || (expire_date > Time.now)
  end

  def current_user
    is_valid? ? user : nil
  end

  def auth_token
    token
  end

  [:email, :name, :image].each do |field|
    define_method(field) { current_user.try(field) }
  end
end
