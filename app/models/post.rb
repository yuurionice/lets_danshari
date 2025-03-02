require 'carrierwave/orm/activerecord'

class Post < ApplicationRecord
  belongs_to :item
  mount_uploader :image, ImageUploader # 画像アップロード用
end
