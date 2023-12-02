require 'rails_helper'

RSpec.describe 'Static home page', type: :feature do
  it 'should get a static home page when the user is not authenticated' do
    visit(unauthenticated_root_path)
    expect(page).to have_http_status :ok
    expect(page).to have_content('Welcome to Budget, a simple budgeting app.')
    expect(page).to have_link('Sign up')
    expect(page).to have_link('Sign in')
  end
end
