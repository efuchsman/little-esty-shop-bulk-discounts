require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item)}
    it { should have_many(:bulk_discounts).through(:merchant)}
  end

  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :invoice_id }
  end

  describe "Instance Methods" do

    before :each do
      @customer_1 = Customer.create!(first_name: 'Eli', last_name: 'Fuchsman')

      @merchant = Merchant.create!(name: 'Test')

      @discount1 = BulkDiscount.create!(name: "Test1", percentage: 10, quantity_threshold: 10, merchant: @merchant)

      @item_1 = Item.create!(name: 'item1', description: 'desc1', unit_price: 12053, merchant_id: @merchant.id)
      @item_2 = Item.create!(name: 'item2', description: 'desc1', unit_price: 11000, merchant_id: @merchant.id)

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 12053, status: 1)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 6, unit_price: 11000, status: 1)
    end

    describe "#unit_price_to_dollars" do
      it "converts cents to dollars" do
        expect(@ii_1.unit_price_to_dollars).to eq(120.53)
      end
    end

    describe "#discount?" do
      it "returns true if an invoice item meets a discount quantity threshold" do
        expect(@ii_1.discount?).to be true
        expect(@ii_2.discount?).to be false
      end
    end

    describe "#return_available_discounts" do
      it 'returns the available discounts for a bulk purchase' do
        discount2 = BulkDiscount.create!(name: "Test2", percentage: 8, quantity_threshold: 8, merchant: @merchant)
        expect(@ii_1.return_available_discounts).to eq([@discount1, discount2])
      end
    end
  end
end
