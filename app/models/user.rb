class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :entries
  has_many :categories
  validates :name, presence: true, length: { maximum: 30 }
end
