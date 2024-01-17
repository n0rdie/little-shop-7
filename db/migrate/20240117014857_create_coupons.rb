class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :percent_off
      t.integer :dollar_off
      t.integer :merchant_id
      t.integer :invoice_id
      t.integer :status

      t.timestamps
    end
  end
end
