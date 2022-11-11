class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]
  before_action :find_discount_and_merchant, only: [:destroy, :show, :edit, :update]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
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

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
      flash[:message] = 'Information successfully updated'
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
      flash[:error] = 'Required content missing or number input(s) are invalid'
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_discount_and_merchant
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity_threshold)
  end


end
