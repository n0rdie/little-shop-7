require "rails_helper"

RSpec.describe "Merchant Dashboards", type: :feature do
  before(:each) do
    @merchant_1 = Merchant.create(name: "Chucky Cheese")
    @item_1 = @merchant_1.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_1.id)
    @item_3 = @merchant_1.items.create(name: "Fortnite Amongus", description: "ew", unit_price: 20, merchant_id: @merchant_1.id)
    @customer_1 = Customer.create(first_name: "Steve", last_name: "Minecraft")
    @invoice_1 = @customer_1.invoices.create(customer: @customer_1, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice_1, item: @item_1, quantity: 5, unit_price: @item_1.unit_price, status: "packaged")
    InvoiceItem.create!(invoice: @invoice_1, item: @item_3, quantity: 10, unit_price: @item_3.unit_price, status: "packaged")

    @merchant_2 = Merchant.create(name: "Freddy Fazbear's")
    @item_2 = @merchant_2.items.create(name: "Cheese Pizza", description: "ew", unit_price: 1199, merchant_id: @merchant_1.id)
    @customer_2 = Customer.create(first_name: "Steve", last_name: "Minecraft")
    @invoice_2 = @customer_2.invoices.create(customer: @customer_1, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice_2, item: @item_2, quantity: 5, unit_price: @item_2.unit_price, status: "packaged")
  end 

  it "15. Merchant Invoice Show Page" do 
    # When I visit my merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit "merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    # Then I see information related to that invoice including:
    # - Invoice id
    expect(page).to have_content(@invoice_1.id)
    # - Invoice status
    expect(page).to have_content(@invoice_1.status)
    # - Invoice created_at date in the format "Monday, July 18, 2019"
    expect(page).to have_content(@invoice_1.created_at.strftime('%A, %B %d, %Y'))
    # - Customer first and last name
    expect(page).to have_content(@customer_1.first_name)
    expect(page).to have_content(@customer_1.last_name)
  end

  it "16. Merchant Invoice Show Page: Invoice Item Information" do
    # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit "merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    # Then I see all of my items on the invoice including:
    # - Item name
    expect(page).to have_content(@item_1.name)
    # - The quantity of the item ordered
    expect(page).to have_content("5")
    # - The price the Item sold for
    expect(page).to have_content(@item_1.unit_price)
    # - The Invoice Item status
    expect(page).to have_content("packaged")
    # And I do not see any information related to Items for other merchants
    expect(page).to_not have_content(@item_2.name)
  end

  it "17. Merchant Invoice Show Page: Total Revenue" do
    # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit "merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    # Then I see the total revenue that will be generated from all of my items on the invoice
    expect(page).to have_content("6195")
  end

  it "18. Merchant Invoice Show Page: Update Item Status" do
    # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit "merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    # I see that each invoice item status is a select field
    # And I see that the invoice item's current status is selected
    # When I click this select field,
    # Then I can select a new status for the Item,
    within '.items' do
        within "#item-#{@item_1.id}" do
            expect(page).to have_content("Status packaged")
            page.select "shipped"
        end
    end
    # And next to the select field I see a button to "Update Item Status"
    within '.items' do
        within "#item-#{@item_1.id}" do
            expect(page).to have_button("Update Item Status")
        end
    end
    # When I click this button
    within '.items' do
        within "#item-#{@item_1.id}" do
            click_button "Update Item Status"
        end
    end
    # I am taken back to the merchant invoice show page
    expect(page).to have_current_path("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
    # And I see that my Item's status has now been updated
    within '.items' do
        within "#item-#{@item_1.id}" do
            expect(page).to have_content("Status shipped")
            expect(page).to_not have_content("Status packaged")
        end
        within "#item-#{@item_3.id}" do
            page.select "pending"
            click_button "Update Item Status"
        end
    end

    expect(page).to have_current_path("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
    within '.items' do
        within "#item-#{@item_3.id}" do
            expect(page).to have_content("Status pending")
            expect(page).to_not have_content("Status packaged")
        end
    end
  end

  it "7. Merchant Invoice Show Page: Subtotal and Grand Total Revenues -- Dollar" do
    @merchant_3 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_3.coupons.create(name: "$10 off", code: "10off", dollar_off: 1000, status: 0)
    @item_4 = @merchant_3.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_3.id)
    @item_5 = @merchant_3.items.create(name: "Fortnite Amongus", description: "ew", unit_price: 20, merchant_id: @merchant_3.id)
    @invoice_3 = @coupon_1.invoices.create(coupon_id: @coupon_1.id, customer: @customer_1, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_4, quantity: 5, unit_price: @item_4.unit_price, status: "packaged")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_5, quantity: 10, unit_price: @item_5.unit_price, status: "packaged")
    # When I visit one of my merchant invoice show pages
    visit "merchants/#{@merchant_3.id}/invoices/#{@invoice_3.id}"
    # And I see the name and code of the coupon used as a link to that coupon's show page.
    expect(page).to have_content(@coupon_1.name)
    expect(page).to have_link(@coupon_1.code)
    # I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
    expect(page).to have_content(6195)
    # And I see the grand total revenue after the discount was applied
    expect(page).to have_content(5195)
    
    click_on(@coupon_1.code)
    expect(page).to have_current_path("/merchants/#{@merchant_3.id}/coupons/#{@coupon_1.id}")
  end

  it "7. Merchant Invoice Show Page: Subtotal and Grand Total Revenues -- Percent" do
    @merchant_3 = Merchant.create(name: "Chucky Cheese")
    @coupon_1 = @merchant_3.coupons.create(name: "$10 off", code: "10off", percent_off: 5, status: 0)
    @item_4 = @merchant_3.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_3.id)
    @item_5 = @merchant_3.items.create(name: "Fortnite Amongus", description: "ew", unit_price: 20, merchant_id: @merchant_3.id)
    @invoice_3 = @coupon_1.invoices.create(coupon_id: @coupon_1.id, customer: @customer_1, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_4, quantity: 5, unit_price: @item_4.unit_price, status: "packaged")
    InvoiceItem.create!(invoice: @invoice_3, item: @item_5, quantity: 10, unit_price: @item_5.unit_price, status: "packaged")
    # When I visit one of my merchant invoice show pages
    visit "merchants/#{@merchant_3.id}/invoices/#{@invoice_3.id}"
    # And I see the name and code of the coupon used as a link to that coupon's show page.
    expect(page).to have_content(@coupon_1.name)
    expect(page).to have_link(@coupon_1.code)
    # I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
    expect(page).to have_content(6195)
    # And I see the grand total revenue after the discount was applied
    expect(page).to have_content(5885)
    
    click_on(@coupon_1.code)
    expect(page).to have_current_path("/merchants/#{@merchant_3.id}/coupons/#{@coupon_1.id}")
  end
end 
