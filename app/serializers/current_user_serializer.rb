class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :image
end
