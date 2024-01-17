class Admin::MerchantsController < ApplicationController
  layout 'admin/layouts/admin'

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.enabled? ? merchant.disabled! : merchant.enabled!

    redirect_to admin_merchants_path
  end

  def new
    @merchant = Merchant.new
  end

  def create
    merchant = Merchant.create(merchant_params)

    redirect_to admin_merchants_path
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update_info
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      flash[:notice] = "Merchant information updated."
      redirect_to admin_merchant_path(@merchant)
    else
      render :edit # NOT QUINS, NOT DELETING IT INCASE IT BREAKS SOMETHING
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
