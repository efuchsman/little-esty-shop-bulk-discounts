# 5: Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Edit page" do

  before :each do
    @merchant = Merchant.create!(name: 'Marvel')
    @discount1 = BulkDiscount.create!(name: "Test1", percentage: 10, quantity_threshold: 10, merchant: @merchant)
  end

  describe "As a merchant" do
    describe "When I visit my bulk discount show page" do
      it "Then I see a link to edit the bulk discount" do
        visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}"

        expect(page).to have_link("Edit")
      end

      describe "When I click this link" do
        it "Then I am taken to a new page with a form to edit the discount. And I see that the discounts current attributes are pre-populated in the form" do
          visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}"

          click_link("Edit")

          expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")
          # save_and_open_page

          within('#update_discount') do
            expect(page).to have_content('Name:')
            expect(page).to have_field(:bulk_discount_name, with: "Test1")
            expect(page).to have_content('Discount percentage:')
            expect(page).to have_field(:bulk_discount_percentage, with: 10)
            expect(page).to have_content('Quantity required:')
            expect(page).to have_field(:bulk_discount_quantity_threshold, with: 10)
            expect(page).to have_button('Update Discount')
          end
        end

        describe "When I correctly change any/all of the information and click submit" do
          it "Then I am redirected to the bulk discount's show page. And I see that the discount's attributes have been updated" do
            visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit"

            within('#update_discount') do
              fill_in(:bulk_discount_name, with: "Test2")
              fill_in(:bulk_discount_percentage, with: 10)
              fill_in(:bulk_discount_quantity_threshold, with: 10)
              click_button('Update Discount')
            end

            expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}")
            expect(page).to have_content('Information successfully updated')
            expect(page).to have_content("Test2 Show Page")
            expect(page).to_not have_content("Test1 Show Page")
          end
        end
        describe "Sad path testing" do
          describe "When I leave a form blank" do
            it "I am redirected back to the edit page and an error message is displayed" do
              visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit"

              within('#update_discount') do
                fill_in(:bulk_discount_name, with: "")
                fill_in(:bulk_discount_percentage, with: 20)
                fill_in(:bulk_discount_quantity_threshold, with: 20)
                click_button('Update Discount')
              end

              expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")
              expect(page).to have_content('Required content missing or number input(s) are invalid')
            end
          end

          describe "When I fill in percentage with a negative number" do
            it "I am redirected back to the new page and an error message is displayed" do
              visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit"

              within('#update_discount') do
                fill_in(:bulk_discount_name, with: "Test1")
                fill_in(:bulk_discount_percentage, with: -20)
                fill_in(:bulk_discount_quantity_threshold, with: 20)
                click_button('Update Discount')
              end

              expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")
              expect(page).to have_content('Required content missing or number input(s) are invalid')
            end
          end

          describe "When I fill in quantity_threshold with a negative number" do
            it "I am redirected back to the new page and an error message is displayed" do
              visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit"

              within('#update_discount') do
                fill_in(:bulk_discount_name, with: "Test1")
                fill_in(:bulk_discount_percentage, with: 20)
                fill_in(:bulk_discount_quantity_threshold, with: -20)
                click_button('Update Discount')
              end

              expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount1.id}/edit")
              expect(page).to have_content('Required content missing or number input(s) are invalid')
            end
          end
        end
      end
    end
  end
end
