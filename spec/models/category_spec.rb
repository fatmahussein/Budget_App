require 'rails_helper'

RSpec.describe Category, type: :model do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
  end

  it 'is valid entry' do
    expect(Category.create(name: 'Fruit', icon: 'apple', user: @user)).to be_valid
  end

  it 'is not valid with blank name' do
    expect(Category.create(icon: 'apple', user: @user)).to_not be_valid
  end

  it 'is not valid without an icon' do
    expect(Category.create(name: 'Fruit', user: @user)).to_not be_valid
  end
end
