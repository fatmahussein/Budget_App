require 'rails_helper'

RSpec.describe 'entries/new', type: :view do
  before(:each) do
    assign(:entry, Entry.new)
    assign(:categories, [Category.new(id: 1, name: 'Category 1', icon: 'icon1')])
  end

  it 'renders the new entry form' do
    render

    expect(rendered).to have_selector('h1', text: 'New transaction')

    expect(rendered).to render_template(partial: '_form')

    expect(rendered).to have_link('Back to transactions', href: entries_path)

    assert_select 'form[action=?][method=?]', entries_path, 'post' do
      assert_select 'input[name=?]', 'entry[name]'
      assert_select 'input[name=?]', 'entry[amount]'

      assert_select 'input[type=?]', 'checkbox' do
        assert_select '[name=?]', 'entry[category_ids][]'
      end

      assert_select 'input[type=?]', 'submit'
    end
  end
end
