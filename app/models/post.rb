require 'carrierwave/orm/activerecord'

class Post < ApplicationRecord
  belongs_to :item
  belongs_to :user, optional: true # ユーザーとの関連付けを追加
  mount_uploader :image, ImageUploader # 画像アップロード用
end
