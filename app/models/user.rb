class User < ActiveRecord::Base
  after_create :generate_authentication_token!
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities, dependent: :destroy
  has_many :email_accounts, dependent: :destroy
  has_many :sessions, dependent: :destroy

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
      (!!super) && identities.empty?
    end

    def password_required?
      (!!super) && identities.empty?
    end
end
