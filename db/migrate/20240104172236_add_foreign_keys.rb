class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :invoices, :customers
    add_foreign_key :items, :merchants
    add_foreign_key :invoice_items, :items
    add_foreign_key :invoice_items, :invoices
    add_foreign_key :transactions, :invoices
    add_foreign_key :coupons, :merchants
  end
end
