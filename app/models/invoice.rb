class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer#, optional: true
  belongs_to :coupon, optional: true

  enum status: {
    "cancelled": 0,
    "in progress": 1,
    "completed": 2
  }
  def self.incomplete_invoices
    joins(:invoice_items)
      .where(invoice_items: { status: [:packaged, :pending] })
      .where(status: "in progress")
      .distinct
      .order(created_at: :asc)
  end

  def subtotal_revenue
    invoice_items
      .sum("quantity * unit_price")
  end

  def revenue_of_only_couponed_items
    if self.coupon
      coupon_merchant = coupon.merchant
      invoice_items
        .joins(item: :merchant)
        .where(item: { merchant: coupon_merchant })
        .sum("quantity * invoice_items.unit_price")
    else
      0
    end
  end

  def total_revenue
    return invoice_items.sum("quantity * unit_price") unless self.coupon != nil && self.coupon.status = 0
    
    if self.coupon.dollar_off != nil
      if self.coupon.dollar_off < self.revenue_of_only_couponed_items
        self.subtotal_revenue - self.coupon.dollar_off
      else
        self.subtotal_revenue - self.revenue_of_only_couponed_items
      end
    elsif self.coupon.percent_off != nil
      (self.subtotal_revenue - self.revenue_of_only_couponed_items + (self.revenue_of_only_couponed_items * (100-self.coupon.percent_off) / 100)).to_f.ceil
    end
    
  end

end
