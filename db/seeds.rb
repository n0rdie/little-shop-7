# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@customer_1 = Customer.create!(id: 22211, first_name: "Steve", last_name: "Minecraft")

@merchant_1 = Merchant.create!(id: 22211, name: "Chucky Cheese")

@coupon_1 = @merchant_1.coupons.create!(id: 22211, name: "$10 off", code: "orghnsogi", percent_off: 5, status: 0)

@item_1 = @merchant_1.items.create!(id: 22211, name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_1.id)

@item_2 = @merchant_1.items.create!(id: 22212, name: "Fortnite Amongus", description: "ew", unit_price: 20, merchant_id: @merchant_1.id)

@invoice_1 = @coupon_1.invoices.create!(id: 22211, coupon_id: @coupon_1.id, customer: @customer_1, created_at: 5.days.ago, status: "in progress")

InvoiceItem.create!(invoice: @invoice_1, item: @item_1, quantity: 5, unit_price: @item_1.unit_price, status: "packaged")

InvoiceItem.create!(invoice: @invoice_1, item: @item_2, quantity: 10, unit_price: @item_2.unit_price, status: "packaged")
