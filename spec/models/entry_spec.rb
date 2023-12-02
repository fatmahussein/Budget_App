require 'rails_helper'

RSpec.describe Entry, type: :model do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @category2 = Category.create(name: 'Vegetable', icon: 'carrot', user: @user)
  end

  it 'is valid entry' do
    expect(Entry.create(name: 'Meal', user: @user, amount: 9.99, categories: [@category])).to be_valid
  end

  it 'Allows multiple categories' do
    expect(Entry.create(name: 'Meal', user: @user, amount: 9.99, categories: [@category, @category2])).to be_valid
  end

  it 'is not valid with blank name' do
    expect(Entry.create(user: @user, amount: 9.99, categories: [@category])).to_not be_valid
  end

  it 'is not valid with blank amount' do
    expect(Entry.create(name: 'Meal', user: @user, categories: [@category])).to_not be_valid
  end

  it 'is not valid without categories' do
    expect(Entry.create(name: 'Meal', user: @user, amount: 9.99)).to_not be_valid
  end
end
