class MessageSerializer < ApplicationSerializer
  attributes :id, :body, :created_at
  belongs_to :sender
  class UserSerializer < ApplicationSerializer
    attributes :id, :name, :image
  end
end
