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

  it "4. Merchant Coupon Deactivate" do 
    # When I visit one of my active coupon's show pages
    visit "/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}"
    # I see a button to deactivate that coupon
    expect(page).to have_button("Activate/Deactivate")
    # When I click that button
    click_on("Activate/Deactivate")
    # I'm taken back to the coupon show page
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}")
    # And I can see that its status is now listed as 'inactive'.
    expect(page).to have_content("inactive")
    #expect(@coupon_1.status).to eq("inactive")
  end

  it "5. Merchant Coupon Activate" do 
    visit "/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}"
    click_on("Activate/Deactivate")
    # When I visit one of my inactive coupon show pages
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}")
    # I see a button to activate that coupon
    expect(page).to have_button("Activate/Deactivate")
    # When I click that button
    click_on("Activate/Deactivate")
    # I'm taken back to the coupon show page
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons/#{@coupon_1.id}")
    # And I can see that its status is now listed as 'active'.
    expect(page).to have_content("active")
    expect(@coupon_1.status).to eq("active")
  end
end 