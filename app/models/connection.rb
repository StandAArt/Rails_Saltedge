class Connection < ApplicationRecord
  belongs_to :customer
  has_many :accounts
end
