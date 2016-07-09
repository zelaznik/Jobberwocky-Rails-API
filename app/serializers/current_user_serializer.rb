class CurrentUserSerializer < ActiveModel::Serializer
  attributes :email, :name, :image, :auth_token
  root 'current_user'
end
