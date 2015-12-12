Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['facebook_app_id'], ENV['facebook_app_secret'],
           scope: 'email, user_friends, public_profile', display: 'popup',
           client_options: {
               site: 'https://graph.facebook.com/v2.2',
               authorize_url: "https://www.facebook.com/v2.2/dialog/oauth"
           }
end
