class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      Rails.logger.debug "Google OAuth2 callback started"
      callback_for(:google)
    end

    def callback_for(provider)
      begin
        # 認証情報をログに出力（パスワードなどの機密情報を除く）
        auth_info = request.env['omniauth.auth']
        Rails.logger.debug "Auth provider: #{auth_info.provider}, uid: #{auth_info.uid}"
        Rails.logger.debug "Auth info: #{auth_info.info.email}, name: #{auth_info.info.name}"
        
        @user = User.from_omniauth(auth_info)
        
        if @user.persisted?
          Rails.logger.debug "User persisted successfully: #{@user.id}"
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
        else
          Rails.logger.error "User could not be persisted: #{@user.errors.full_messages.join(', ')}"
          session["devise.#{provider}_data"] = auth_info.except(:extra)
          redirect_to new_user_registration_url
        end
      rescue => e
        Rails.logger.error "Error in callback_for #{provider}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        redirect_to new_user_registration_url
      end
    end

    def failure
      Rails.logger.error "OAuth failure: #{params[:message]}"
      redirect_to root_path
    end
  end