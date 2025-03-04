require 'rails_helper'

RSpec.describe 'admin/merchants-show page' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Marvel')
    @merchant_2 = Merchant.create!(name: 'D.C.')
    @merchant_3 = Merchant.create!(name: 'Darkhorse')
    @merchant_4 = Merchant.create!(name: 'Image')
  end

  it 'When the user updates the information in the form and click submit' do
    visit "/admin/merchants/#{@merchant_1.id}"

    expect(page).to have_link('Update Merchant')
    click_link 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}/edit")

    fill_in :name, with: 'Ms. Marvel'
    click_button('Submit')

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")
    expect(page).to have_content('Successfully Updated: Ms. Marvel')
    expect(page).to have_content('Ms. Marvel')
  end

  it 'returns an error message when the name field is empty' do
    visit "/admin/merchants/#{@merchant_1.id}"

    expect(page).to have_link('Update Merchant')
    click_link 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}/edit")

    fill_in :name, with: ''
    click_button('Submit')

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}/edit")
    expect(page).to have_content('Empty name not permitted. Please input valid name')
  end
end
