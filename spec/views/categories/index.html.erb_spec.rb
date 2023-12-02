require 'rails_helper'

RSpec.describe 'categories/index', type: :view do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    assign(:categories, [])
  end

  it 'renders the categories view with no categories' do
    render

    assert_select 'h1', text: 'Categories'
    assert_select '#categories' do
      assert_select 'p', text: 'No categories yet'
    end
    assert_select 'a.btn.btn-outline-secondary', text: 'Add a New Category'
  end

  context 'with categories' do
    before(:each) do
      @user = User.create!(name: 'muba', email: 'muba@example.com', password: '123abc')
      @category = Category.create!(name: 'Fruit', icon: 'banana', user: @user)
      assign(:categories, Category.all)
    end

    it 'renders the categories' do
      render

      assert_select 'h1', text: 'Categories'
      assert_select '#categories' do
        assert_select 'div.category-actions' do
          assert_select 'a[href=?]', category_path(@category), text: 'Show this category'
          assert_select 'a[href=?]', category_entries_path(@category), text: 'Show all transactions'
        end
        assert_select "div#category_#{@category.id}.d-flex" do
          assert_select 'div.fs-1', text: 'banana'
          assert_select 'div.d-flex.category-name' do
            assert_select 'strong', text: 'Name:'
            assert_select 'p', text: 'Fruit'
          end
        end
      end
      assert_select 'a.btn.btn-outline-secondary', text: 'Add a New Category'
    end
  end
end
