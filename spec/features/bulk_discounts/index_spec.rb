require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Index Page" do

  before :each do
    @merchant = Merchant.create!(name: 'Marvel')
    @discount1 = BulkDiscount.create!(name: "Test1", percentage: 10, quantity_threshold: 10, merchant: @merchant)
    @discount2 = BulkDiscount.create!(name: "Test2", percentage: 15, quantity_threshold: 15, merchant: @merchant)
  end

  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      it "Then I see a link to view all my discounts" do
        visit "/merchants/#{@merchant.id}/dashboard"

        expect(page).to have_link("View Discounts")
      end

      describe "When I click this link" do
        it "Then I am taken to my bulk discounts index page" do
          visit "/merchants/#{@merchant.id}/dashboard"

          click_link("View Discounts")

          expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
        end

        it "Where I see all of my bulk discounts including their percentage discount and quantity thresholds" do

          visit "/merchants/#{@merchant.id}/bulk_discounts"

          expect(page).to have_content("Marvel Discount Index")

          within("#discount-#{@discount1.id}") do
            expect(page).to have_content("Name: Test1")
            expect(page).to have_content("Deal: 10% off")
            expect(page).to have_content("Quantity Required: 10")
          end

          within("#discount-#{@discount2.id}") do
            expect(page).to have_content("Name: Test2")
            expect(page).to have_content("Deal: 15% off")
            expect(page).to have_content("Quantity Required: 15")
          end

        end

        it "And each bulk discount listed includes a link to its show page" do
          visit "/merchants/#{@merchant.id}/bulk_discounts"
          # save_and_open_page
          within("#discount-#{@discount1.id}") do
            expect(page).to have_link("Visit")
          end

          within("#discount-#{@discount2.id}") do
            expect(page).to have_link("Visit")
          end
        end
      end
    end

    describe "When I visit my bulk discounts index" do
      it "Then next to each bulk discount I see a button to delete it" do
        visit "/merchants/#{@merchant.id}/bulk_discounts"

        within("#discount-#{@discount1.id}") do
          expect(page).to have_button("Delete This Discount")
        end

        within("#discount-#{@discount2.id}") do
          expect(page).to have_button("Delete This Discount")
        end

      end

      describe "When I click this button" do
        it "Then I am redirected back to the bulk discounts index page. And I no longer see the discount listed" do
          visit "/merchants/#{@merchant.id}/bulk_discounts"

          within("#discount-#{@discount2.id}") do
            click_button("Delete This Discount")
          end

          expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
          expect(page).to_not have_content("Name: Test2")
          expect(page).to_not have_content("Deal: 15% off")
          expect(page).to_not have_content("Quantity Required: 15")
        end
      end
    end
  end
end
