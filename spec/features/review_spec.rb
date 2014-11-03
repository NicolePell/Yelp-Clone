require 'rails_helper'

describe 'reviewing' do
	before do
		Restaurant.create(name: "Nando's")
	end

	it 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link "Review Nando's"
		fill_in 'Thoughts', with: 'awesome'
		select '5', from: 'Rating'
		click_button 'Leave Review'

		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('awesome')
	end
end