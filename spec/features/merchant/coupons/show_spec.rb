require "rails_helper"

RSpec.describe "Coupon Show", type: :feature do
  before(:each) do
    @merchant_1 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_1.coupons.create(name: "$10 off", code: "10off", dollar_off: 10)
    @coupon_2 = @merchant_1.coupons.create(name: "5% off", code: "5off", percent_off: 5)

    @customer = Customer.create
    @invoice_1 = @customer.invoices.create(coupon_id: @coupon_2.id, status: 2)
    @transaction_1 = @invoice_1.transactions.create(invoice_id: @invoice_1.id, result: 1)
    @transaction_2 = @invoice_1.transactions.create(invoice_id: @invoice_1.id, result: 0)
  end 

  it "3. Merchant Coupon Show Page" do 
    # When I visit a merchant's coupon show page
    visit "/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}"
    # I see that coupon's name and code 
    expect(page).to have_content(@coupon_1.name)
    expect(page).to have_content(@coupon_1.code)
    # And I see the percent/dollar off value
    expect(page).to have_content(@coupon_1.dollar_off)
    # As well as its status (active or inactive)
    expect(page).to have_content("active")
    # And I see a count of how many times that coupon has been used.
    expect(page).to have_content("Used: 0 times")
  end

  it "3. Merchant Coupon Show Page" do 
    # When I visit a merchant's coupon show page
    visit "/merchants/#{@merchant_1.id}/coupons/#{@coupon_2.id}"
    # And I see a count of how many times that coupon has been used.
    expect(page).to have_content("Used: 1 times")
  end
end 