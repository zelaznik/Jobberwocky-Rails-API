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
    create(name: info['name'])
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user_params = {
          name: auth.extra.raw_info.name,
          password: Devise.friendly_token[0,20]
        }
        user = User.create(user_params)
        if user.respond_to?(:skip_confirmation)
          user.skip_confirmation!
        end
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    return user
  end

  protected
    def email_required?
      (!!super) && identities.empty?
    end

    def password_required?
      (!!super) && identities.empty?
    end
end
