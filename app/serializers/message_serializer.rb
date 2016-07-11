class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  belongs_to :sender
end
