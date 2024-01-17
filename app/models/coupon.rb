class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true

  enum status: {
    disabled: 0,
    enabled: 1
  }
end
