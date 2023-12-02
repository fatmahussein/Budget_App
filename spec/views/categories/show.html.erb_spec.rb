require 'rails_helper'

RSpec.describe 'categories/show', type: :view do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @entry = Entry.create(name: 'Apple', amount: 9.99, categories: [@category], user: @user)
  end

  it 'renders category data' do
    render
    expect(rendered).to have_text('apple')
    expect(rendered).to have_text('Fruit')
  end

  it 'renders actions to edit, back and destroy' do
    render
    expect(rendered).to have_link('Edit this category', href: edit_category_path(@category))
    expect(rendered).to have_link('Back to categories', href: categories_path)
    expect(rendered).to have_button('Destroy this category')
  end
end
