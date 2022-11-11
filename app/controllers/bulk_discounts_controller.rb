class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.new(name: params[:name],
                                                  percentage: params[:percentage],
                                                  quantity_threshold: params[:quantity_threshold])
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:error] = 'Required content missing or number input(s) are invalid'
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

end
