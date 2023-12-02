require 'rails_helper'

RSpec.describe '/categories', type: :feature do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @user2 = User.create(name: 'Bob', email: 'bob@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @category2 = Category.create(name: 'Vegetable', icon: 'carrot', user: @user)
    @category3 = Category.create(name: 'Meat', icon: 'drumstick-bite', user: @user)
    @category4 = Category.create(name: 'Dairy', icon: 'cheese', user: @user2)
    @entry = Entry.create(name: 'Apple', amount: 9.99, categories: [@category], user: @user)
    @entry2 = Entry.create(name: 'Carrot', amount: 4.99, categories: [@category2, @category3], user: @user)
    @entry3 = Entry.create(name: 'Cheese', amount: 2.99, categories: [@category4], user: @user2)

    visit new_user_session_path
    fill_in 'Email', with: 'lily@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'
    sleep(1)
    visit(authenticated_root_path)
  end

  it 'has successful response' do
    expect(page).to have_http_status(:ok)
  end

  it 'has a list of categories' do
    expect(page).to have_content('Fruit')
    expect(page).to have_content('Vegetable')
    expect(page).to have_content('Meat')
    expect(page).to_not have_content('Dairy')
  end

  it 'allows the user to create a new category' do
    click_link 'Add a New Category'
    fill_in 'Name', with: 'Grains'
    select '🏛️', from: 'Icon'
    click_button 'Save'
    sleep(1)
    expect(page).to have_content('Grains')
    expect(page).to have_content('🏛️')
  end

  it 'allows the user to edit a category' do
    visit category_path(@category)
    click_link 'Edit this category'
    fill_in 'Name', with: 'Legumes'
    select '🍴', from: 'Icon'
    click_button 'Save'
    sleep(1)
    expect(page).to have_content('Legumes')
    expect(page).to have_content('🍴')
  end

  it 'allows the user to delete a category' do
    visit category_path(@category)
    click_button 'Destroy this category'
    sleep(1)
    expect(page).to_not have_content('Fruit')
  end

  it 'prevents an unauthorized user from editing or viewing a category from other user' do
    visit category_path(@category4)
    expect(page).to have_content('You are not authorized to access this page.')
  end
end
