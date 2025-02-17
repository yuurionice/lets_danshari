class Item < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :danshari_at, presence: true
end
