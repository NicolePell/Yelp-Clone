require 'rails_helper'

describe 'restaurants' do
	context 'no restaurants have been added' do
		it 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants'
			expect(page).to have_link 'Add a restaurant'
		end
	end

	context 'restaurants have been added' do
		before do 
			Restaurant.create(name: "Nando's")
		end

		it 'should display restaurants' do
			visit '/restaurants'
			expect(page).to have_content("Nando's")
			expect(page).not_to have_content('No restaurants yet')
		end
	end
end

describe 'creating restaurants' do
	it 'prompts user to fill out a form, then displays the new restaurant' do
		visit '/restaurants'
		click_link 'Add a restaurant'
		fill_in 'Name', with: "Nando's"
		click_button 'Create Restaurant'
		expect(page).to have_content "Nando's"
		expect(current_path).to eq '/restaurants'
	end

	context 'an invalid restaurant' do
		it 'does not let you submit a name that is too short' do
			visit '/restaurants'
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'N'
			click_button 'Create Restaurant'
			expect(page).not_to have_css 'h2', text: 'N'
			expect(page).to have_content 'error'
		end
		
		it 'is not valid unless it has a unique name' do
			Restaurant.create(name: "Moe's Tavern")
			restaurant = Restaurant.new(name: "Moe's Tavern")
			expect(restaurant).to have(1).error_on(:name)
		end
	end

	context 'viewing restaurants' do

		before do
			@nandos = Restaurant.create(name: "Nando's")
		end

		it 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link "Nando's"
			expect(page).to have_content "Nando's"
			expect(current_path).to eq "/restaurants/#{@nandos.id}"
		end
	end

	context 'editing restaurants' do
		before do
			Restaurant.create(name: "Nando's")
		end

		it 'lets a user edit a restaurant' do
			visit '/restaurants'
			click_link "Edit Nando's"
			fill_in 'Name', with: "Nando's Chickenland"
			click_button 'Update Restaurant'
			expect(page).to have_content "Nando's Chickenland"
			expect(current_path).to eq '/restaurants'
		end
	end
end

describe 'deleting restaurants' do
	before do
		Restaurant.create(name: "Nando's")
	end

	it 'removes a restaurant when a user clicks a delete link' do
		visit '/restaurants'
		click_link "Delete Nando's"
		expect(page).not_to have_content "Nando's"
		expect(page).to have_content 'Restaurant deleted successfully'
	end
end
