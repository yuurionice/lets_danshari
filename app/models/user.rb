class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :items, dependent: :destroy
  has_many :posts

  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? && provider.present? }

  def self.from_omniauth(auth)
    begin
      user = User.find_by(email: auth.info.email)

      if user
        # 既存ユーザーのプロバイダとUIDを更新
        Rails.logger.debug "Found existing user with email: #{auth.info.email}, updating OAuth credentials"
        user.update(provider: auth.provider, uid: auth.uid)
        return user
      else
      Rails.logger.debug "Creating new user with email: #{auth.info.email}"
      user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
      user.name = auth.info.name if user.respond_to?(:name)
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      if user.save
        Rails.logger.debug "User saved successfully"
        return user
      else
        Rails.logger.error "Failed to save user: #{user.errors.full_messages.join(', ')}"
        return user
      end
    end
    rescue => e
      Rails.logger.error "Exception in from_omniauth: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return nil
    end
  end
end