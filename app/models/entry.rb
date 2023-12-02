class Entry < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  validates :name, presence: true, length: { maximum: 50 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :category_ids, presence: { message: 'must have at least one category' }
end
