class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :criteria
  has_many :messages, dependent: :destroy
end
