require 'rails_helper'

RSpec.describe 'categories/edit', type: :view do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    assign(:icons, ['🏛️', '🍴', '🏠', '🏫', '🗑️', '🧾', '💰', '🍹', '✈️', '🚗', '🚇'])
  end

  it 'renders the new category form' do
    render

    expect(rendered).to have_selector('h1', text: 'Editing category')

    expect(rendered).to render_template(partial: '_form')

    expect(rendered).to have_link('Back to categories', href: categories_path)

    assert_select 'form[action=?][method=?]', category_path(@category), 'post' do
      assert_select 'input[name=?]', 'category[name]'

      assert_select 'select[name=?]', 'category[icon]'

      assert_select 'input[type=?]', 'submit'
    end
  end
end
