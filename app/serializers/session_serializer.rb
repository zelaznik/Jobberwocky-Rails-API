class SessionSerializer < ActiveModel::Serializer
  attributes :token, :expire_date
  belongs_to :user, serializer: UserSerializer
end
