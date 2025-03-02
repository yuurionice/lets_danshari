class Item < ApplicationRecord
  belongs_to :user
  has_one :post

  validates :name, presence: true
  validates :danshari_at, presence: true
end
