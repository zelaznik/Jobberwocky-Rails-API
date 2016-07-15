class User < ActiveRecord::Base
  after_create :generate_authentication_token!
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities,     inverse_of: :user, dependent: :destroy
  has_many :email_accounts, inverse_of: :user, dependent: :destroy
  has_many :sessions,       inverse_of: :user, dependent: :destroy

  def self.find_for_oauth(auth, *args)
    Identity.find_for_oauth(auth).user
  end

  def image
    identities.map {|i| i.image }.first
  end

  def generate_authentication_token!
    Session.create! user: self, token: Devise.friendly_token, expire_date: Time.now + 1.day
  end

  protected
  def email_required?
    false
  end

  def password_required?
    false
  end
end
