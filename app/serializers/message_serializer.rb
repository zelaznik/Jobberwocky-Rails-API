class MessageSerializer < ApplicationSerializer
  attributes :id, :body, :created_at
  belongs_to :sender
end
