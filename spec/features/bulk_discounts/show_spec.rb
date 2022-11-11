require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Show page" do

  before :each do
    @merchant = Merchant.create!(name: 'Marvel')
    @discount1 = BulkDiscount.create!(name: "Test1", percentage: 10, quantity_threshold: 10, merchant: @merchant)
  end

  describe "As a merchant" do
    describe "When I visit my bulk discount show page" do
      it "# Then I see the bulk discount's quantity threshold and percentage discount" do
        visit "/merchants/#{@merchant.id}/bulk_discounts"

        within("#discount-#{@discount1.id}") do
          click_link("Visit")
        end

        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}")
        expect(page).to have_content("Test1 Show Page")
        expect(page).to have_content("Deal: 10% off")
        expect(page).to have_content("Quantity Required: 10")
      end
    end
  end
end
