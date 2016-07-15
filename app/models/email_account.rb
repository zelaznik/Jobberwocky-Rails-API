class EmailAccount < ActiveRecord::Base
  belongs_to :user, inverse_of: :email_accounts
end
