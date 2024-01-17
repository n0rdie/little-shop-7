require "rails_helper"
require "rake"
Rails.application.load_tasks

RSpec.describe Coupon, type: :model do

  describe "relationships" do
    it {should belong_to(:merchant)}
    it {should have_many(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

end
