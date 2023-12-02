require 'rails_helper'

RSpec.describe EntriesController, type: :routing do
  before(:each) do
    Entry.delete_all
    Category.delete_all
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @category = Category.create(name: 'Fruit', icon: 'apple', user: @user)
    @entry = Entry.create(name: 'Apple', amount: 9.99, categories: [@category], user: @user)
  end

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/entries').to route_to('entries#index')
    end

    it 'routes to #new' do
      expect(get: '/entries/new').to route_to('entries#new')
    end

    it 'routes to #show' do
      expect(get: '/entries/1').to route_to('entries#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/entries/1/edit').to route_to('entries#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/entries').to route_to('entries#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/entries/1').to route_to('entries#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/entries/1').to route_to('entries#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/entries/1').to route_to('entries#destroy', id: '1')
    end
  end
end
