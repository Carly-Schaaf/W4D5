require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  background :each do
    visit new_user_path
  end

  scenario 'has a new user page' do
    expect(page).to have_content('Sign up')
  end

  feature 'signing up a user' do

    scenario 'shows username on the homepage after signup' do
      user = FactoryBot.build(:user)
      fill_in "Username", with: user.username
      fill_in "Password", with: user.password

      click_button "Create user!"

      expect(page).to have_content(user.username)
    end
  end
end

feature 'logging in' do
  background :each do
    visit new_session_path
  end

  scenario 'shows username on the homepage after login' do
    user = FactoryBot.build(:user)
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password

    click_button "Login!"

    expect(page).to have_content(user.username)
  end
end

feature 'logging out' do
  user = FactoryBot.create(:user)
  background :each do
    visit new_session_path
  end

  scenario 'begins with a logged out state' do
    expect(page).not_to have_content(user.username)
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Login!"
    
    click_button "Logout!"

    expect(page).not_to have_content(user.username)
  end

end
