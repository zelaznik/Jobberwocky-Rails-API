class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)
    identity.raw = auth.to_json
    send "#{auth[:provider]}_parse", auth, identity
    identity.user = User.find_or_create_by(email: identity.email)
    identity.user.name ||= identity.name
    identity.user.save!
    identity.save!
    return identity
  end

  private
  def self.facebook_parse(auth, ity)
    onErrSkip { ity.name = auth["info"]["name"]  }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.link = auth["info"]["link"]  }
    onErrSkip { ity.email = auth["info"]["email"]  }
  end

  def self.twitter_parse(auth, ity)
    onErrSkip { ity.name = auth["info"]["name"]   }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.link = auth["info"]["link"]   }
    onErrSkip { ity.email = auth["info"]["email"] }
  end

  def self.github_parse(auth, ity)
    onErrSkip { ity.name = auth["info"]["name"]   }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.email = auth["info"]["email"] }
    onErrSkip { ity.link = auth["info"]["urls"]["GitHub"]   }
  end

  def self.google_oauth2_parse(auth, ity)
    onErrSkip { ity.name = auth["info"]["name"]   }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.email = auth["info"]["email"] }
  end

  def self.onErrSkip
    begin
      return yield
    rescue Exception
    end
  end

  def parse_oauth_response
    self.raw = auth.to_json

    self.user = User.find_or_create_by(email: email)

    user.save!
  end
end
