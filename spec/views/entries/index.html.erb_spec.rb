require 'rails_helper'

RSpec.describe 'entries/index', type: :view do
  before(:each) do
    @user = User.create!(name: 'bladee', email: 'joe@test.com', password: 'password')
    @category_one = Category.create!(name: 'Fruit', icon: 'apple', user: @user)
    @category_two = Category.create!(name: 'Vegetable', icon: 'carrot', user: @user)
    assign(:entries, [
             Entry.create!(user: @user, name: 'Tomato', amount: 10.05, categories: [@category_one]),
             Entry.create!(user: @user, name: 'Lettuce', amount: 15.05, categories: [@category_two])
           ])
  end

  it 'renders the index view' do
    render

    expect(rendered).to have_selector('h1', text: 'Transactions')

    expect(rendered).to have_selector('table#entries')

    expect(rendered).to have_link('Add a new transaction entry', href: new_entry_path, class: 'btn-outline-secondary')

    assert_select 'table#entries tbody tr' do
      assert_select 'th a', text: 'Tomato', href: entry_path(Entry.first)
      assert_select 'td', text: '$ 10.05'
      assert_select 'td a', text: 'Fruit', href: category_path(Category.first)
    end

    assert_select 'table#entries tbody tr' do
      assert_select 'th a', text: 'Lettuce', href: entry_path(Entry.last)
      assert_select 'td', text: '$ 15.05'
      assert_select 'td a', text: 'Vegetable', href: category_path(Category.last)
    end
  end

  context 'when there are no entries' do
    before(:each) do
      assign(:entries, [])
    end

    it 'displays a message about no transactions' do
      render

      expect(rendered).to have_content('No transactions yet')
    end
  end

  context 'when a category_id is present in params' do
    it 'displays a link to add a new transaction entry with the category_id' do
      allow(view).to receive(:params).and_return(category_id: @category_one.id)
      render

      expect(rendered).to have_link('Add a new transaction entry', href: new_category_entry_path(@category_one.id),
                                                                   class: 'btn-outline-secondary')
    end
  end

  context 'when a category_id is NOT present in params' do
    it 'displays a link to add a new transaction entry without category_id' do
      render

      expect(rendered).to have_link('Add a new transaction entry', href: new_entry_path, class: 'btn-outline-secondary')
    end
  end
end
