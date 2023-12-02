require 'rails_helper'

RSpec.describe 'categories/new', type: :view do
  before(:each) do
    assign(:category, Category.new)
    assign(:icons, ['🏛️', '🍴', '🏠', '🏫', '🗑️', '🧾', '💰', '🍹', '✈️', '🚗', '🚇'])
  end

  it 'renders the new category form' do
    render

    expect(rendered).to have_selector('h1', text: 'New category')

    expect(rendered).to render_template(partial: '_form')

    expect(rendered).to have_link('Back to categories', href: categories_path)

    assert_select 'form[action=?][method=?]', categories_path, 'post' do
      assert_select 'input[name=?]', 'category[name]'

      assert_select 'select[name=?]', 'category[icon]'

      assert_select 'input[type=?]', 'submit'
    end
  end
end
