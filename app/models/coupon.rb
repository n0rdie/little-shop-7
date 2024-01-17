class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  has_many :invoices
  has_many :transactions, through: :invoices
  attribute :status, default: -> { 0 }

  enum status: {
    active: 0,
    inactive: 1
  }

  def times_used
    transactions.where("transactions.result = 1").count
  end
end
