require "rails_helper"

RSpec.describe "Merchant Dashboards", type: :feature do
  it "shows the name of the merchant" do 
    load_data
    visit "/merchants/#{@merchant.id}/dashboard"

    expect(page).to have_content(@merchant.name)
  end

  it "has links to the merchant items index and the merchant invoices index" do 
    load_data

    visit "/merchants/#{@merchant.id}/dashboard"
    expect(page).to have_link("Items")
    expect(page).to have_link("Invoices")

    click_link "Items" 
    expect(current_path).to eq("/merchants/#{@merchant.id}/items")

    visit "/merchants/#{@merchant.id}/dashboard"

    click_link "Invoices" 
    expect(current_path).to eq("/merchants/#{@merchant.id}/invoices")
  end

  it "has a list of the top five customers who have conducted the largest number of transactions with a merchant" do 
    load_data

    visit "/merchants/#{@merchant.id}/dashboard"
    within ".top-five-cust" do 
      expect("#{@customers[4].last_name}, #{@customers[4].first_name}").to appear_before("#{@customers[7].last_name}, #{@customers[7].first_name}")
      expect("#{@customers[7].last_name}, #{@customers[7].first_name}").to appear_before("#{@customers[3].last_name}, #{@customers[3].first_name}")
      expect("#{@customers[3].last_name}, #{@customers[3].first_name}").to appear_before("#{@customers[1].last_name}, #{@customers[1].first_name}")
      expect("#{@customers[1].last_name}, #{@customers[1].first_name}").to appear_before("#{@customers[5].last_name}, #{@customers[5].first_name}")
    end
  end

  it "has a section that displays the names of all items that have been ordered but not yet shipped called 'Items Ready to Ship'" do 
    merchant = create(:merchant)
    merchant.items = create_list(:item, 5)

    5.times do
      create(:invoice_item, status: rand(0..1), item_id: merchant.items.sample.id)
    end
    3.times do
      create(:invoice_item, status: 2, item_id: merchant.items.sample.id)
    end

    visit "/merchants/#{merchant.id}/dashboard"

    within ".items-to-ship" do 
      expect(page).to have_content("Items Ready to Ship")
      merchant.items.ready_to_ship.each do |item|
        expect(page).to have_content(item.name)
        expect(page).to have_content(item.invoice_id)
      end
    end
    
    within ".items-to-ship" do 
      merchant.items.each do |item|
        if !merchant.items.ready_to_ship.include? (item)
          item.invoice_items.each do |inv_item|
            expect(page).to_not have_content(inv_item.invoice_id) # ALSO NOT QUINS
          end
        end
      end
    end
  end
  
  it "each invoice ID displayed next to an item to be shipped is a link to that invoice's show page" do 
    merchant = create(:merchant)
    merchant.items = create_list(:item, 5)

    5.times do
      create(:invoice_item, status: rand(0..1), item_id: merchant.items.sample.id)
    end
    3.times do
      create(:invoice_item, status: 2, item_id: merchant.items.sample.id)
    end
    
    visit "/merchants/#{merchant.id}/dashboard"
    
    within ".items-to-ship" do 
      merchant.items.ready_to_ship.each do |item|
        visit "/merchants/#{merchant.id}/dashboard"
        expect(page).to have_link(item.invoice_id.to_s)
        click_link "#{item.invoice_id}"
        expect(current_path).to eq(merchant_invoice_path(merchant_id: item.merchant.id, id: item.invoice_id))
      end
    end
  end

  it "within the 'Items to Ship' section, next to the Invoice ID link is the date on which the invoice was created (formatted like - Monday, July 18, 2019)" do 
    merchant = create(:merchant)
    merchant.items = create_list(:item, 5)

    5.times do
      create(:invoice_item, status: rand(0..1), item_id: merchant.items.sample.id)
    end
    3.times do
      create(:invoice_item, status: 2, item_id: merchant.items.sample.id)
    end

    Invoice.all.each do |invoice| 
      invoice.update!(created_at: Date.today - rand(1..180))
    end

    visit "/merchants/#{merchant.id}/dashboard"

    within ".items-to-ship" do 
      merchant.items.ready_to_ship.each do |item|
        visit "/merchants/#{merchant.id}/dashboard"
        expect(page).to have_content(item.invoice_date.strftime("%A, %B %d, %Y"))
      end
    end
  end
end 