require "rails_helper"


RSpec.describe "the admin invoices show" do
  before :each do
    @test_customer = Customer.create!(first_name: "Test", last_name: "Customer")
    @merchant = Merchant.create!(name: "Test Merchant")
    @item = Item.create!(name: "Test Item", description: "Test Description", unit_price: 100, merchant: @merchant)

    @invoice1 = Invoice.create!(customer: @test_customer, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice1, item: @item, quantity: 5, unit_price: 100, status: "packaged")
  end

  it "displays the correct information for an invoice" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content("In progress")

    formatted_date = @invoice1.created_at.strftime("%A, %B %d, %Y")
    expect(page).to have_content(formatted_date)

    expect(page).to have_content(@invoice1.customer.first_name)
    expect(page).to have_content(@invoice1.customer.last_name)
  end

  it "displays invoice item data on a table" do
    visit admin_invoice_path(@invoice1)

    within "table" do
      expect(page).to have_content(@item.name)
      expect(page).to have_content("5")
      expect(page).to have_content("$1.00")
      expect(page).to have_content("Packaged")
    end
  end

  it "displays the total invoice revenue" do
    visit admin_invoice_path(@invoice1)
    
    total_invoice_revenue = number_to_currency(@invoice1.total_revenue / 100.0)
    expect(page).to have_content("Total Revenue: #{total_invoice_revenue}")
  end

  it "allows the admin to update the invoice status" do
    visit admin_invoice_path(@invoice1)

    select "Completed", from: "Status" 
    click_button "Update Invoice Status"

    expect(current_path).to eq(admin_invoice_path(@invoice1))
    expect(page).to have_content("Invoice status updated.")
    expect(page).to have_content("Completed")
  end

  it "8. Admin Invoice Show Page: Subtotal and Grand Total Revenues" do
    @customer_1 = Customer.create(first_name: "Steve", last_name: "Minecraft")
    @merchant_3 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_3.coupons.create(name: "$10 off", code: "10off", percent_off: 5, status: 0)
    @item_4 = @merchant_3.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_3.id)
    @item_5 = @merchant_3.items.create(name: "Fortnite Amongus", description: "ew", unit_price: 20, merchant_id: @merchant_3.id)
    @invoice_3 = @coupon_1.invoices.create(coupon_id: @coupon_1.id, customer: @customer_1, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_4, quantity: 5, unit_price: @item_4.unit_price, status: "packaged")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_5, quantity: 10, unit_price: @item_5.unit_price, status: "packaged")
    # When I visit one of my admin invoice show pages
    visit "/admin/invoices/#{@invoice_3.id}"
    # I see the name and code of the coupon that was used (if there was a coupon applied)
    expect(page).to have_content(@coupon_1.name)
    expect(page).to have_content(@coupon_1.code)
    # And I see both the subtotal revenue from that invoice (before coupon) 
    expect(page).to have_content(6195)
    # and the grand total revenue (after coupon) for this invoice.
    expect(page).to have_content(5885)
  end
end