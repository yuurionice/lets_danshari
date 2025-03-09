class Item < ApplicationRecord
  belongs_to :user
  has_many :post, dependent: :destroy

  validates :name, presence: true
  validates :danshari_at, presence: true
end
