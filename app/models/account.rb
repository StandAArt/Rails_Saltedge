class Account < ApplicationRecord
  belongs_to :connection
  has_many :transactions

  before_destroy :destroy_transactions

  private

  def destroy_transactions
    transactions.destroy_all
  end
end
