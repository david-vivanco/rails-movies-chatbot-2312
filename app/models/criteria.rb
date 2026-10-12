class Criteria < ApplicationRecord
  has_one :conversation, dependent: :destroy
end
