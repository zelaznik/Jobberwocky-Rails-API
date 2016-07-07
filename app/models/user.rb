class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :identities, inverse_of: :user, dependent: :destroy

  after_create :generate_authentication_token!

  def generate_authentication_token!
    self.auth_token = Devise.friendly_token
    save!
  end

  def self.create_with_omniauth(info)
    create(name: info['name'])
  end

  def self.facebook_parse(auth, ity)
    ity.provider = auth["provider"]
    ity.uid      = auth["uid"]

    ity.name     = auth["info"]["name"]
    ity.image    = auth["info"]["image"]
    ity.link     = auth["info"]["link"]

    # ity.gender   = auth["info"]["gender"]
    # ity.token    = auth["credentials"]["token"]
    # ity.expires  = auth["credentials"]["expires_at"]
  end

  def self.twitter_parse(auth, ity)
    begin
      ity.provider = auth[:provider]
      ity.uid      = auth[:uid]
      ity.auth = auth.to_json
    rescue
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    identity.raw = auth.to_json
    identity.save!
    if auth[:provider] == 'facebook'
      facebook_parse(auth, identity)
    elsif auth[:provider] == 'twitter'
      twitter_parse(auth, identity)
    end

    identity.save
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user_params = {
          name: auth.extra.raw_info.name,
          email: email ? email : "uid-#{auth.uid}-#{auth.provider}@#{ENV['DOMAIN_NAME']}",
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
end
