class SessionSerializer < ApplicationSerializer
  attributes :token, :expire_date
  belongs_to :user, serializer: UserSerializer
end
