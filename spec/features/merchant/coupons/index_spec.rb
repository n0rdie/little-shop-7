require "rails_helper"

RSpec.describe "Coupon Index", type: :feature do
  before(:each) do
    @merchant_1 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_1.coupons.create(name: "$10 off", code: "10off", dollar_off: 10)
    @coupon_2 = @merchant_1.coupons.create(name: "5% off", code: "5off", percent_off: 5)
  end 

  it "1. Merchant Coupons Index" do 
    # When I visit my merchant dashboard page
    visit "/merchants/#{@merchant_1.id}/dashboard"
    # I see a link to view all of my coupons
    expect(page).to have_link("View my coupons")
    # When I click this link
    click_link("View my coupons")
    # I'm taken to my coupons index page
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons")
    #save_and_open_page
    # Where I see all of my coupon names including their amount off
    expect(page).to have_content("$10")
    expect(page).to have_content("5%")
    # And each coupon's name is also a link to its show page.
    expect(page).to have_link(@coupon_1.name)
    expect(page).to have_link(@coupon_2.name)
  end
end 