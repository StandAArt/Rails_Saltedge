class Customer < ApplicationRecord
  belongs_to :user
  has_many :connections
end
