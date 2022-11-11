require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts New Page" do

  before :each do
    @merchant = Merchant.create!(name: 'Marvel')
    @discount1 = BulkDiscount.create!(name: "Test1", percentage: 10, quantity_threshold: 10, merchant: @merchant)
    @discount2 = BulkDiscount.create!(name: "Test2", percentage: 15, quantity_threshold: 15, merchant: @merchant)
  end

  describe "When I visit my bulk discounts index" do
    it "Then I see a link to create a new discount" do
      visit "/merchants/#{@merchant.id}/bulk_discounts"

      expect(page).to have_link("Create a Discount")
    end

    describe "When I click this link" do
      it "Then I am taken to a new page where I see a form to add a new bulk discount" do
        visit "/merchants/#{@merchant.id}/bulk_discounts"
        click_link("Create a Discount")

        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")


        within('#create_discount') do
          expect(page).to have_content('Name:')
          expect(page).to have_field(:name)
          expect(page).to have_content('Discount percentage:')
          expect(page).to have_field(:percentage)
          expect(page).to have_content('Quantity required:')
          expect(page).to have_field(:quantity_threshold)
          expect(page).to have_button('Create Discount')
        end

      end

      describe "When I fill in the form with valid data" do
        it "Then I am redirected back to the bulk discount index. And I see my new bulk discount listed" do
          visit "/merchants/#{@merchant.id}/bulk_discounts/new"

          within('#create_discount') do
            fill_in(:name, with: "Test3")
            fill_in(:percentage, with: 20)
            fill_in(:quantity_threshold, with: 20)
            click_button('Create Discount')
          end

          expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")

          expect(page).to have_content("Name: Test1")
          expect(page).to have_content("Name: Test2")
          expect(page).to have_content("Name: Test3")
        end
      end

      describe "Sad path testing" do
        describe "When I leave a form blank" do
          it "I am redirected back to the new page and an error message is displayed" do
            visit "/merchants/#{@merchant.id}/bulk_discounts/new"

            within('#create_discount') do
              fill_in(:name, with: "")
              fill_in(:percentage, with: 20)
              fill_in(:quantity_threshold, with: 20)
              click_button('Create Discount')
            end

            expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
            expect(page).to have_content('Required content missing or number input(s) are invalid')
          end
        end

        describe "When I fill in percentage with a negative number" do
          it "I am redirected back to the new page and an error message is displayed" do
            visit "/merchants/#{@merchant.id}/bulk_discounts/new"

            within('#create_discount') do
              fill_in(:name, with: "Test3")
              fill_in(:percentage, with: -20)
              fill_in(:quantity_threshold, with: 20)
              click_button('Create Discount')
            end

            expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
            expect(page).to have_content('Required content missing or number input(s) are invalid')
          end
        end

        describe "When I fill in quantity_threshold with a negative number" do
          it "I am redirected back to the new page and an error message is displayed" do
            visit "/merchants/#{@merchant.id}/bulk_discounts/new"

            within('#create_discount') do
              fill_in(:name, with: "Test3")
              fill_in(:percentage, with: 20)
              fill_in(:quantity_threshold, with: -20)
              click_button('Create Discount')
            end

            expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
            expect(page).to have_content('Required content missing or number input(s) are invalid')
          end
        end
      end
    end
  end
end
