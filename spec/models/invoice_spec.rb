require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should have_many (:transactions)}
    it {should have_many (:invoice_items)}
    it {should have_many(:items).through(:invoice_items)}
    it {should belong_to (:customer)}
    # it {should belong_to (:coupon)}
    # If you set the :optional option to true, then the presence of the associated object won't be validated.
  end
end
