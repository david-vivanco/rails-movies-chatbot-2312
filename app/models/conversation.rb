class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :criteria
  has_many :messages, dependent: :destroy

  def summary
    messages.order(created_at: :asc).first&.content || "Nouvelle conversation"
  end

  def started_on
    created_at.strftime("%d %B %Y") # "9 January"
  end
end
