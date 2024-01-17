require "rails_helper"

RSpec.describe "Coupon Create", type: :feature do
  before(:each) do
    @merchant_1 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_1.coupons.create(name: "$10 off", code: "10off", dollar_off: 10)
    @coupon_2 = @merchant_1.coupons.create(name: "5% off", code: "5off", percent_off: 5)
  end 

  it "2. Merchant Coupon Create" do 
    # When I visit my coupon index page
    visit "/merchants/#{@merchant_1.id}/coupons"
    # I see a link to create a new coupon.
    expect(page).to have_link("Create new coupon")
    # When I click that link 
    click_on("Create new coupon")
    # I am taken to a new page where I see a form to add a new coupon.
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons/new")
    expect(page).to have_field("Name")
    expect(page).to have_field("Code")
    expect(page).to have_field("Percent off")
    expect(page).to have_field("Dollar off")
    # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
    fill_in "Name", with: "Free!"
    fill_in "Code", with: "freeday"
    fill_in "Percent off", with: "100"
    # And click the Submit button
    click_on("Submit")
    # I'm taken back to the coupon index page 
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons")
    # And I can see my new coupon listed.
    expect(page).to have_content("Free!")

    click_on("Create new coupon")
    fill_in "Name", with: "Superday"
    fill_in "Code", with: "superday"
    fill_in "Dollar off", with: "100"
    click_on("Submit")
    expect(page).to have_content("Superday")
  end

  it "2. Merchant Coupon Create -- SAD (no input)" do 
    visit "/merchants/#{@merchant_1.id}/coupons"
    click_on("Create new coupon")

    fill_in "Name", with: "Nothing"
    fill_in "Code", with: "Nothing"
    fill_in "Percent off", with: ""
    fill_in "Dollar off", with: ""

    click_on("Submit")

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons")
    expect(page).to_not have_content("Nothing")
  end

  it "2. Merchant Coupon Create -- SAD (too many active coupons)" do 
    coupon_3 = @merchant_1.coupons.create(name: "agepin", code: "rouesbg", dollar_off: 10)
    coupon_4 = @merchant_1.coupons.create(name: "obg", code: "ojaegs", dollar_off: 10)
    coupon_5 = @merchant_1.coupons.create(name: "egpnia", code: "bgour", dollar_off: 10)

    visit "/merchants/#{@merchant_1.id}/coupons"
    click_on("Create new coupon")

    fill_in "Name", with: "Nothing"
    fill_in "Code", with: "Nothing"
    fill_in "Percent off", with: "5"

    click_on("Submit")

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons")
    
    expect(page).to_not have_content("Nothing")

    click_on("Create new coupon")

    fill_in "Name", with: "Supersale"
    fill_in "Code", with: "Supersale"
    fill_in "Dollar off", with: "10"

    click_on("Submit")

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/coupons")
    
    expect(page).to_not have_content("Supersale")
  end
end 