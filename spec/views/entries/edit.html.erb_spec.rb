require 'rails_helper'

RSpec.describe 'entries/edit', type: :view do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category_one = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @category_two = Category.create(name: 'Vegetable', icon: 'carrot', user: @user)
    @entry = Entry.create(name: 'Apple', amount: 9.99, categories: [@category_one, @category_two], user: @user)
    @categories = [@category_one, @category_two]
  end
  it 'renders the edit entry form' do
    render

    expect(rendered).to have_selector('h1', text: 'Editing transaction')

    expect(rendered).to render_template(partial: '_form')

    expect(rendered).to have_link('Show this transaction', href: entry_path(@entry), class: 'btn btn-link')
    expect(rendered).to have_link('Back to transactions', href: entries_path, class: 'btn btn-link')

    assert_select 'form[action=?][method=?]', entry_path(@entry), 'post' do
      assert_select 'input[name=?]', 'entry[name]'
      assert_select 'input[name=?]', 'entry[amount]'

      assert_select 'input[type=?]', 'checkbox' do
        assert_select '[name=?]', 'entry[category_ids][]'
      end

      assert_select 'input[type=?]', 'submit'
    end
  end
end
