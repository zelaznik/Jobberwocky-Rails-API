class MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender, :body, :created_at
end
