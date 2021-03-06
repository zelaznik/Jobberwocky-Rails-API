class Message < ActiveRecord::Base
  belongs_to :sender,   class_name: "User", foreign_key: :sender_id
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id

  scope :between, -> (a, b) do
    where(thread_id: [a, b].map(&:to_i).sort.join(".")).order(:created_at)
  end
end
