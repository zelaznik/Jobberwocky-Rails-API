def onErrSkip
  begin
    return yield
  rescue Exception
    return nil
  end
end

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)
    identity.raw = auth.to_json
    identity.save!

    if auth[:provider] == 'facebook'
      facebook_parse auth, identity
    elsif auth[:provider] == 'twitter'
      twitter_parse auth, identity
    elsif auth[:provider] == 'github'
      github_parse auth, identity
    end

    identity.save!
    return identity
  end

  private

  def self.facebook_parse(auth, ity)
    ity.provider = auth["provider"]
    ity.uid      = auth["uid"]

    onErrSkip { ity.name = auth["info"]["name"]  }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.link = auth["info"]["link"]  }
    onErrSkip { ity.email = auth["info"]["email"]  }
  end

  def self.twitter_parse(auth, ity)
    ity.provider = auth["provider"]
    ity.uid      = auth["uid"]

    onErrSkip { ity.name = auth["info"]["name"]   }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.link = auth["info"]["link"]   }
    onErrSkip { ity.email = auth["info"]["email"] }
  end

  def self.github_parse(auth, ity)
    ity.provider = auth["provider"]
    ity.uid      = auth["uid"]

    onErrSkip { ity.name = auth["info"]["name"]   }
    onErrSkip { ity.image = auth["info"]["image"] }
    onErrSkip { ity.email = auth["info"]["email"] }
    onErrSkip { ity.link = auth["info"]["urls"]["GitHub"]   }
  end
end
