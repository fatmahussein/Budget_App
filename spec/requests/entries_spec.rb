require 'rails_helper'

RSpec.describe '/entries', type: :feature do
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

  it 'has a list of entries' do
    visit entries_path
    expect(page).to have_content('Apple')
    expect(page).to have_content('Carrot')
    expect(page).to_not have_content('Cheese')
  end

  it 'allows the user to create a new entry' do
    visit entries_path
    click_link 'Add a new transaction entry'
    fill_in 'Name', with: 'Deer'
    fill_in 'Amount', with: '3.99'
    check 'Meat'
    click_button 'Save'
    sleep(1)
    expect(page).to have_content('Deer')
    expect(page).to have_content('3.99')
    expect(page).to have_content('Meat')
  end

  it 'allows the user to edit an entry' do
    visit entry_path(@entry)
    click_link 'Edit this entry'
    fill_in 'Name', with: 'Strawberry'
    fill_in 'Amount', with: '1.99'
    check 'Vegetable'
    uncheck 'Fruit'
    click_button 'Save'
    sleep(1)
    expect(page).to have_content('Strawberry')
    expect(page).to have_content('1.99')
    expect(page).to have_content('Vegetable')
  end

  it 'allows the user to delete an entry' do
    visit entry_path(@entry)
    click_button 'Destroy this entry'
    sleep(1)
    expect(page).to_not have_content('Apple')
  end

  it 'prevents an unauthorized user from editing or viewing an entry from other user' do
    visit entry_path(@entry3)
    expect(page).to have_content('You are not authorized to access this page.')
  end
end
