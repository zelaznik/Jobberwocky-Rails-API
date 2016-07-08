class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :image, :auth_token
  root 'users'
end
