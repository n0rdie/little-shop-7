class Merchant::CouponsController < ApplicationController 
    
    def index 
        @merchant = Merchant.find(params[:merchant_id])
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create
        merchant = Merchant.find(params[:merchant_id])
        if params[:name].length > 0 && params[:code].length > 0
            if params[:percent_off].length > 0
                merchant.coupons.create(name: params[:name], code: params[:code], percent_off: params[:percent_off].to_i, merchant_id: params[:merchant_id])
            elsif params[:dollar_off].length > 0
                merchant.coupons.create(name: params[:name], code: params[:code], dollar_off: params[:dollar_off].to_i, merchant_id: params[:merchant_id])
            end
        end
        redirect_to "/merchants/#{params[:merchant_id]}/coupons"
    end

    def show
        @coupon = Coupon.find(params[:id])
    end
end