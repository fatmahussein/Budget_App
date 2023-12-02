require 'rails_helper'

RSpec.describe 'entries/show', type: :view do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @entry = Entry.create(name: 'Apple', amount: 9.99, categories: [@category], user: @user)
  end

  it 'renders entry data' do
    render
    expect(rendered).to have_text('Apple')
    expect(rendered).to have_text('9.99')
    expect(rendered).to have_text('Fruit')
  end

  it 'renders actions to edit, back and destroy' do
    render
    expect(rendered).to have_link('Edit this entry', href: edit_entry_path(@entry))
    expect(rendered).to have_link('Back to entries', href: entries_path)
    expect(rendered).to have_button('Destroy this entry')
  end
end
