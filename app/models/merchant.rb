class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :coupons
  validates :name, presence: true

  enum status: {
    disabled: 0,
    enabled: 1
  }

  def num_active_coupons
    coupons.where("status = 0").count
  end

  def self.top_5_merchants
    Merchant.joins(invoice_items: [invoice: :transactions])
      .select("merchants.*", "sum(invoice_items.quantity * invoice_items.unit_price) as sales")
      .where("transactions.result = ?", "1")
      .group("merchants.id")
      .order("sales desc")
      .limit(5)
  end

  def date_with_most_sales
    Invoice.joins(:transactions, [items: :merchant])
    .select("invoices.created_at", "(invoice_items.quantity * invoice_items.unit_price) as sales")
    .where("transactions.result = ?", "1")
    .where("merchants.id = ?", self.id)
    .order("sales desc", "created_at desc", "invoices.id")
    .first.created_at.strftime("%Y-%m-%d")
  end
end
