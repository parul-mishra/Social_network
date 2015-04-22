class OmniauthCallbacksController < Devise::OmniauthCallbacksController

=begin
  skip_before_filter :authenticate_user!
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
      if user.persisted?
        redirect_to new_user_registration_url
      end
      alias_method :facebook, :all
    end
  end
=end

  def facebook
    create
  end

  def twitter
    create
  end

 private

    def create
      auth_params = request.env["omniauth.auth"]
      
      identity = Identity.where(uid: auth_params.uid).first

      provider = auth_params.provider
      
      existing_user = current_user || User.where('email = ?', auth_params['info']['email']).first

      if identity
        sign_in_with_existing_identity(identity)
      elsif existing_user
        create_identity_and_sign_in(auth_params, existing_user, provider)
      else
        create_user_and_identity_and_sign_in(auth_params, provider)
      end
    end

    def sign_in_with_existing_identity(identity)
      sign_in_and_redirect(:user, identity.user)
    end

    def create_identity_and_sign_in(auth_params, user, provider)
      Identity.create_from_omniauth(auth_params, user, provider)

      sign_in_and_redirect(:user, user)
    end

    def create_user_and_identity_and_sign_in(auth_params, provider)
      user = User.create_from_omniauth(auth_params, provider)
      if user.valid?
        #user.skip_confirmation!
        begin
          user.avatar = process_uri(auth_params['info']['image']) if auth_params['info']['image'].present?
        rescue
        end
        user.save

        create_identity_and_sign_in(auth_params, user, provider)
      else
        flash[:notice] = user.errors.full_messages.first
        redirect_to new_user_session_url, :notice => flash[:notice]
      end
    end

    def process_uri(uri)
      avatar_url = URI.parse(uri)
      avatar_url.scheme = 'https'
      avatar_url.to_s
    end    
 end