class Session < ActiveRecord::Base
  belongs_to :user
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

  def email
    current_user.try(:email)
  end

  def name
    current_user.try(:name)
  end

  def image
    current_user.try(:image)
  end
end
