class User < ActiveRecord::Base
  after_create :generate_authentication_token!
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities, inverse_of: :user, dependent: :destroy
  has_many :email_accounts, inverse_of: :user, dependent: :destroy
  has_many :auth_tokens, inverse_of: :user, dependent: :destroy

  def image
    identities.map {|i| i.image }.first
  end

  def generate_authentication_token!
    self.auth_token = Devise.friendly_token
    save!
  end

  def self.create_with_omniauth(info)
    raise NotImplementedError
    create(name: info['name'])
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    Identity.find_for_oauth(auth).user
  end

  protected
    def email_required?
      false #(!!super) && identities.empty?
    end

    def password_required?
      false #(!!super) && identities.empty?
    end
end
