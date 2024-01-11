require "rails_helper"

RSpec.describe "MerchantItem index", type: :feature do
	it "User Story 6. Merchant Items Index Page" do
		@merchant_1 = Merchant.create(name: "Chucky Cheese")
		@merchant_2 = Merchant.create(name: "McDonalds")
		@item_1 = @merchant_1.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_1.id)
		@item_2 = @merchant_2.items.create(name: "Big Mac", description: "Juicy", unit_price: 29, merchant_id: @merchant_2.id)
		@item_3 = @merchant_2.items.create(name: "Chicken Nuggets", description: "Vegan", unit_price: 15, merchant_id: @merchant_2.id)

		# When I visit my merchant items index page (merchants/:merchant_id/items)
		visit "/merchants/#{@merchant_1.id}/items"
		# I see a list of the names of all of my items
		expect(page).to have_content("Merchant Item List")
		expect(page).to have_content("Chucky Cheese's items")
		# expect(page).to have_content("cookie")
		expect(page).to have_content("Moldy Cheese")
		# And I do not see items for any other merchant
		expect(page).to_not have_content("Big Mac")
	end

	it "10. Merchant Items Grouped by Status" do
		@merchant_1 = Merchant.create(name: "Chucky Cheese")
		@merchant_2 = Merchant.create(name: "McDonalds")
		@item_1 = @merchant_1.items.create(name: "Moldy Cheese", description: "ew", unit_price: 1199, merchant_id: @merchant_1.id)
		@item_2 = @merchant_2.items.create(name: "Big Mac", description: "Juicy", unit_price: 29, merchant_id: @merchant_2.id)
		@item_3 = @merchant_2.items.create(name: "Chicken Nuggets", description: "Vegan", unit_price: 15, merchant_id: @merchant_2.id)
		# When I visit my merchant items index page
		visit "/merchants/#{@merchant_2.id}/items"
		# Then I see two sections, one for "Enabled Items" and one for "Disabled Items"
		within '.enabled-items' do
				expect(page).to have_content("Enabled Items")
		end
		within '.disabled-items' do
				expect(page).to have_content("Disabled Items")
		end
		# And I see that each Item is listed in the appropriate section
		within '.enabled-items' do
				expect(page).to_not have_content("Big Mac")
				expect(page).to_not have_content("Chicken Nuggets")
		end
		within '.disabled-items' do
			expect(page).to have_content("Big Mac")
			expect(page).to have_content("Chicken Nuggets")

			within "#item-#{@item_2.id}" do
					click_on("Enable/Disable")
			end
		end

		within '.enabled-items' do
			expect(page).to have_content("Big Mac")
			expect(page).to_not have_content("Chicken Nuggets")
		end
		within '.disabled-items' do
			expect(page).to_not have_content("Big Mac")
			expect(page).to have_content("Chicken Nuggets")
		end
	end

	it "shows a merchant's top 5 most popular items ranked by total revenue generated" do 
		@merchant = create(:merchant)
		@items = create_list(:item, 8, merchant_id: @merchant.id)
		@customers = create_list(:customer, 8)

		@invoice_1 = create(:invoice, status: rand(1..2), customer_id: @customers[5].id)
		@invoice_2 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id)
		@invoice_3 = create(:invoice, status: rand(1..2), customer_id: @customers[2].id)
		@invoice_4 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id)
		@invoice_5 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id)
		@invoice_6 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id)
		@invoice_7 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id)
		@invoice_8 = create(:invoice, status: rand(1..2), customer_id: @customers[0].id)
		@invoice_9 = create(:invoice, status: rand(1..2), customer_id: @customers[3].id)
		@invoice_10 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id)
		@invoice_11 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id)
		@invoice_12 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id)
		@invoice_13 = create(:invoice, status: rand(1..2), customer_id: @customers[6].id)

		@invoice_item_1 = create(:invoice_item, unit_price: 9000, quantity: 5, invoice_id: @invoice_1.id, item_id: @items[0].id)
		@invoice_item_2 = create(:invoice_item, unit_price: 2000, quantity: 3, invoice_id: @invoice_1.id, item_id: @items[2].id)
		@invoice_item_3 = create(:invoice_item, unit_price: 1200, quantity: 12, invoice_id: @invoice_2.id, item_id: @items[3].id)
		@invoice_item_4 = create(:invoice_item, unit_price: 4600, quantity: 10, invoice_id: @invoice_3.id, item_id: @items[6].id)
		@invoice_item_5 = create(:invoice_item, unit_price: 5500, quantity: 5, invoice_id: @invoice_4.id, item_id: @items[7].id)
		@invoice_item_6 = create(:invoice_item, unit_price: 1350, quantity: 4, invoice_id: @invoice_4.id, item_id: @items[4].id)
		@invoice_item_7 = create(:invoice_item, unit_price: 850, quantity: 10, invoice_id: @invoice_5.id, item_id: @items[2].id)
		@invoice_item_8 = create(:invoice_item, unit_price: 1440, quantity: 15, invoice_id: @invoice_6.id, item_id: @items[7].id)
		@invoice_item_9 = create(:invoice_item, unit_price: 54000, quantity: 11, invoice_id: @invoice_7.id, item_id: @items[1].id)
		@invoice_item_10 = create(:invoice_item, unit_price: 14400, quantity: 6, invoice_id: @invoice_7.id, item_id: @items[5].id)
		@invoice_item_11 = create(:invoice_item, unit_price: 77500, quantity: 1, invoice_id: @invoice_8.id, item_id: @items[4].id)
		@invoice_item_12 = create(:invoice_item, unit_price: 69500, quantity: 10, invoice_id: @invoice_9.id, item_id: @items[1].id)
		@invoice_item_13 = create(:invoice_item, unit_price: 99500, quantity: 5, invoice_id: @invoice_9.id, item_id: @items[3].id)
		@invoice_item_14 = create(:invoice_item, unit_price: 82000, quantity: 8, invoice_id: @invoice_10.id, item_id: @items[1].id)
		@invoice_item_15 = create(:invoice_item, unit_price: 26000, quantity: 12, invoice_id: @invoice_11.id, item_id: @items[5].id)
		@invoice_item_16 = create(:invoice_item, unit_price: 43000, quantity: 25, invoice_id: @invoice_12.id, item_id: @items[0].id)
		@invoice_item_17 = create(:invoice_item, unit_price: 99999, quantity: 15, invoice_id: @invoice_12.id, item_id: @items[6].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 100000, quantity: 20, invoice_id: @invoice_12.id, item_id: @items[4].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 50000, quantity: 8, invoice_id: @invoice_13.id, item_id: @items[4].id)

		@transaction_1 = create(:transaction, result: "failed", invoice_id: @invoice_1.id)
		@transaction_2 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_3 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_4 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_5 = create(:transaction, result: "failed", invoice_id: @invoice_2.id)
		@transaction_6 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_7 = create(:transaction, result: "success", invoice_id: @invoice_3.id)
		@transaction_8 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_9 = create(:transaction, result: "failed", invoice_id: @invoice_5.id)
		@transaction_10 = create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_6.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_7.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_13= create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_14 = create(:transaction, result: "success", invoice_id: @invoice_8.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_16 = create(:transaction, result: "failed", invoice_id: @invoice_9.id)
		@transaction_17 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_18 = create(:transaction, result: "success", invoice_id: @invoice_10.id)
		@transaction_19 = create(:transaction, result: "failed", invoice_id: @invoice_11.id)
		@transaction_19 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_20 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_21 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_22 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_23 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_24 = create(:transaction, result: "failed", invoice_id: @invoice_13.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_25 = create(:transaction, result: "success", invoice_id: @invoice_13.id)

		visit "/merchants/#{@merchant.id}/items"
		
		within ".top-5-rev" do 
			expect(@items[4].name).to appear_before(@items[6].name)
			expect(@items[6].name).to appear_before(@items[0].name)
			expect(@items[0].name).to appear_before(@items[1].name)
			expect(@items[1].name).to appear_before(@items[3].name)
		end
	end

	it "next to each of the five top-selling items is the date with the most sales revenue for that item" do 
		@merchant = create(:merchant)
		@items = create_list(:item, 8, merchant_id: @merchant.id)
		@customers = create_list(:customer, 8)

		@invoice_1 = create(:invoice, status: rand(1..2), customer_id: @customers[5].id, created_at: Date.today-rand(3..200))
		@invoice_2 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id, created_at: Date.today-rand(3..200))
		@invoice_3 = create(:invoice, status: rand(1..2), customer_id: @customers[2].id, created_at: Date.today-rand(3..200))
		@invoice_4 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Date.today-rand(3..200))
		@invoice_5 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Date.today-rand(3..200))
		@invoice_6 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Date.today-rand(3..200))
		@invoice_7 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id, created_at: Date.today-rand(3..200))
		@invoice_8 = create(:invoice, status: rand(1..2), customer_id: @customers[0].id, created_at: Date.today-rand(3..200))
		@invoice_9 = create(:invoice, status: rand(1..2), customer_id: @customers[3].id, created_at: Date.today-rand(3..200))
		@invoice_10 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Date.today-rand(3..200))
		@invoice_11 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Date.today-rand(3..200))
		@invoice_12 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Date.today-rand(3..200))
		@invoice_13 = create(:invoice, status: rand(1..2), customer_id: @customers[6].id, created_at: Date.today-rand(3..200))

		@invoice_item_1 = create(:invoice_item, unit_price: 9000, quantity: 5, invoice_id: @invoice_1.id, item_id: @items[0].id)
		@invoice_item_2 = create(:invoice_item, unit_price: 2000, quantity: 3, invoice_id: @invoice_1.id, item_id: @items[2].id)
		@invoice_item_3 = create(:invoice_item, unit_price: 1200, quantity: 12, invoice_id: @invoice_2.id, item_id: @items[3].id)
		@invoice_item_4 = create(:invoice_item, unit_price: 4600, quantity: 10, invoice_id: @invoice_3.id, item_id: @items[6].id)
		@invoice_item_5 = create(:invoice_item, unit_price: 5500, quantity: 5, invoice_id: @invoice_4.id, item_id: @items[7].id)
		@invoice_item_6 = create(:invoice_item, unit_price: 1350, quantity: 4, invoice_id: @invoice_4.id, item_id: @items[4].id)
		@invoice_item_7 = create(:invoice_item, unit_price: 850, quantity: 10, invoice_id: @invoice_5.id, item_id: @items[2].id)
		@invoice_item_8 = create(:invoice_item, unit_price: 1440, quantity: 15, invoice_id: @invoice_6.id, item_id: @items[7].id)
		@invoice_item_9 = create(:invoice_item, unit_price: 54000, quantity: 11, invoice_id: @invoice_7.id, item_id: @items[1].id)
		@invoice_item_10 = create(:invoice_item, unit_price: 14400, quantity: 6, invoice_id: @invoice_7.id, item_id: @items[5].id)
		@invoice_item_11 = create(:invoice_item, unit_price: 77500, quantity: 1, invoice_id: @invoice_8.id, item_id: @items[4].id)
		@invoice_item_12 = create(:invoice_item, unit_price: 69500, quantity: 10, invoice_id: @invoice_9.id, item_id: @items[1].id)
		@invoice_item_13 = create(:invoice_item, unit_price: 99500, quantity: 5, invoice_id: @invoice_9.id, item_id: @items[3].id)
		@invoice_item_14 = create(:invoice_item, unit_price: 82000, quantity: 8, invoice_id: @invoice_10.id, item_id: @items[1].id)
		@invoice_item_15 = create(:invoice_item, unit_price: 26000, quantity: 12, invoice_id: @invoice_11.id, item_id: @items[5].id)
		@invoice_item_16 = create(:invoice_item, unit_price: 43000, quantity: 25, invoice_id: @invoice_12.id, item_id: @items[0].id)
		@invoice_item_17 = create(:invoice_item, unit_price: 99999, quantity: 15, invoice_id: @invoice_12.id, item_id: @items[6].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 100000, quantity: 20, invoice_id: @invoice_12.id, item_id: @items[4].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 50000, quantity: 8, invoice_id: @invoice_13.id, item_id: @items[4].id)

		@transaction_1 = create(:transaction, result: "failed", invoice_id: @invoice_1.id)
		@transaction_2 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_3 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_4 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_5 = create(:transaction, result: "failed", invoice_id: @invoice_2.id)
		@transaction_6 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_7 = create(:transaction, result: "success", invoice_id: @invoice_3.id)
		@transaction_8 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_9 = create(:transaction, result: "failed", invoice_id: @invoice_5.id)
		@transaction_10 = create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_6.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_7.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_13= create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_14 = create(:transaction, result: "success", invoice_id: @invoice_8.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_16 = create(:transaction, result: "failed", invoice_id: @invoice_9.id)
		@transaction_17 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_18 = create(:transaction, result: "success", invoice_id: @invoice_10.id)
		@transaction_19 = create(:transaction, result: "failed", invoice_id: @invoice_11.id)
		@transaction_19 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_20 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_21 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_22 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_23 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_24 = create(:transaction, result: "failed", invoice_id: @invoice_13.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_25 = create(:transaction, result: "success", invoice_id: @invoice_13.id)

		visit "/merchants/#{@merchant.id}/items"
		
		top_5 = @merchant.items.top_5_by_revenue
		top_5.each do |item| 
			within "#top-item-#{item.id}" do 
				expect(page).to have_content(item.top_selling_date.sale_date.strftime('%A, %B %d, %Y'))
			end
		end
	end

	it "next to each top-5 item it displays a singular date that particular item generated the most revenue" do 
		@merchant = create(:merchant)
		@items = create_list(:item, 8, merchant_id: @merchant.id)
		@customers = create_list(:customer, 8)

		@invoice_1 = create(:invoice, status: rand(1..2), customer_id: @customers[5].id, created_at: Timecop.freeze(Date.today - 64))
		@invoice_2 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id, created_at: Timecop.freeze(Date.today - 2))
		@invoice_3 = create(:invoice, status: rand(1..2), customer_id: @customers[2].id, created_at: Timecop.freeze(Date.today - 23))
		@invoice_4 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Timecop.freeze(Date.today - 56))
		@invoice_5 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Timecop.freeze(Date.today - 0))
		@invoice_6 = create(:invoice, status: rand(1..2), customer_id: @customers[7].id, created_at: Timecop.freeze(Date.today - 3))
		@invoice_7 = create(:invoice, status: rand(1..2), customer_id: @customers[1].id, created_at: Timecop.freeze(Date.today - 10))
		@invoice_8 = create(:invoice, status: rand(1..2), customer_id: @customers[0].id, created_at: Timecop.freeze(Date.today - 98))
		@invoice_9 = create(:invoice, status: rand(1..2), customer_id: @customers[3].id, created_at: Timecop.freeze(Date.today - 12))
		@invoice_10 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Timecop.freeze(Date.today - 43))
		@invoice_11 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Timecop.freeze(Date.today - 77))
		@invoice_12 = create(:invoice, status: rand(1..2), customer_id: @customers[4].id, created_at: Timecop.freeze(Date.today - 39))
		@invoice_13 = create(:invoice, status: rand(1..2), customer_id: @customers[6].id, created_at: Timecop.freeze(Date.today - 21))

		@invoice_item_1 = create(:invoice_item, unit_price: 9000, quantity: 5, invoice_id: @invoice_1.id, item_id: @items[0].id)
		@invoice_item_2 = create(:invoice_item, unit_price: 2000, quantity: 3, invoice_id: @invoice_1.id, item_id: @items[2].id)
		@invoice_item_3 = create(:invoice_item, unit_price: 1200, quantity: 12, invoice_id: @invoice_2.id, item_id: @items[3].id)
		@invoice_item_4 = create(:invoice_item, unit_price: 4600, quantity: 10, invoice_id: @invoice_3.id, item_id: @items[6].id)
		@invoice_item_5 = create(:invoice_item, unit_price: 5500, quantity: 5, invoice_id: @invoice_4.id, item_id: @items[7].id)
		@invoice_item_6 = create(:invoice_item, unit_price: 1350, quantity: 4, invoice_id: @invoice_4.id, item_id: @items[4].id)
		@invoice_item_7 = create(:invoice_item, unit_price: 850, quantity: 10, invoice_id: @invoice_5.id, item_id: @items[2].id)
		@invoice_item_8 = create(:invoice_item, unit_price: 1440, quantity: 15, invoice_id: @invoice_6.id, item_id: @items[7].id)
		@invoice_item_9 = create(:invoice_item, unit_price: 54000, quantity: 11, invoice_id: @invoice_7.id, item_id: @items[1].id)
		@invoice_item_10 = create(:invoice_item, unit_price: 14400, quantity: 6, invoice_id: @invoice_7.id, item_id: @items[5].id)
		@invoice_item_11 = create(:invoice_item, unit_price: 77500, quantity: 1, invoice_id: @invoice_8.id, item_id: @items[4].id)
		@invoice_item_12 = create(:invoice_item, unit_price: 69500, quantity: 10, invoice_id: @invoice_9.id, item_id: @items[1].id)
		@invoice_item_13 = create(:invoice_item, unit_price: 99500, quantity: 5, invoice_id: @invoice_9.id, item_id: @items[3].id)
		@invoice_item_14 = create(:invoice_item, unit_price: 82000, quantity: 8, invoice_id: @invoice_10.id, item_id: @items[1].id)
		@invoice_item_15 = create(:invoice_item, unit_price: 26000, quantity: 12, invoice_id: @invoice_11.id, item_id: @items[5].id)
		@invoice_item_16 = create(:invoice_item, unit_price: 43000, quantity: 25, invoice_id: @invoice_12.id, item_id: @items[0].id)
		@invoice_item_17 = create(:invoice_item, unit_price: 99999, quantity: 15, invoice_id: @invoice_12.id, item_id: @items[6].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 100000, quantity: 20, invoice_id: @invoice_12.id, item_id: @items[4].id)
		@invoice_item_18 = create(:invoice_item, unit_price: 50000, quantity: 8, invoice_id: @invoice_13.id, item_id: @items[4].id)

		@transaction_1 = create(:transaction, result: "failed", invoice_id: @invoice_1.id)
		@transaction_2 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_3 = create(:transaction, result: "success", invoice_id: @invoice_1.id)
		@transaction_4 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_5 = create(:transaction, result: "failed", invoice_id: @invoice_2.id)
		@transaction_6 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_7 = create(:transaction, result: "success", invoice_id: @invoice_3.id)
		@transaction_8 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_9 = create(:transaction, result: "failed", invoice_id: @invoice_5.id)
		@transaction_10 = create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_6.id)
		@transaction_11 = create(:transaction, result: "success", invoice_id: @invoice_4.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_7.id)
		@transaction_12 = create(:transaction, result: "success", invoice_id: @invoice_2.id)
		@transaction_13= create(:transaction, result: "success", invoice_id: @invoice_5.id)
		@transaction_14 = create(:transaction, result: "success", invoice_id: @invoice_8.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_16 = create(:transaction, result: "failed", invoice_id: @invoice_9.id)
		@transaction_17 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_18 = create(:transaction, result: "success", invoice_id: @invoice_10.id)
		@transaction_19 = create(:transaction, result: "failed", invoice_id: @invoice_11.id)
		@transaction_19 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_20 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_21 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_22 = create(:transaction, result: "success", invoice_id: @invoice_12.id)
		@transaction_23 = create(:transaction, result: "success", invoice_id: @invoice_11.id)
		@transaction_24 = create(:transaction, result: "failed", invoice_id: @invoice_13.id)
		@transaction_15 = create(:transaction, result: "success", invoice_id: @invoice_9.id)
		@transaction_25 = create(:transaction, result: "success", invoice_id: @invoice_13.id)

		visit "/merchants/#{@merchant.id}/items"
		save_and_open_page
		top_5 = @merchant.items.top_5_by_revenue
		top_5.each do |item| 
			within "#top-item-#{item.id}" do 
				expect(page).to have_content(
					"Top selling date for #{item.name} was #{item.top_selling_date.sale_date.strftime('%A, %B %d, %Y')}"
					)
			end
		end
	end
end