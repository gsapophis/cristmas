class UserAuthorization < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, presence: true
  validates :uid,  uniqueness: { scope: :provider }

  def self.from_oauth(auth)

    attributes = get_provider_attributes(auth['provider'], auth['credentials']['token'])
    user = find_or_create_user attributes, auth['provider']

    user.profile.create unless user.profile
    user.profile.update(remote_image_url: attributes['avatar']) if user.try(:profile)
    authorization = user.user_authorizations.find_or_create_by!(provider: auth['provider'], user_id: user.id)
    authorization.update_columns(token: auth['credentials']['token'], uid: attributes['id'])
    authorization.reload
  end

  def self.facebook_user(uid)
    find_by(provider: 'facebook', uid: uid).user
  end

  private

  def self.get_img(img)
    img.gsub('http://','https://') if img
  end

  def self.facebook(token)
    @facebook = Koala::Facebook::API.new(token)
  end

  def self.find_or_create_user(attributes, provider)
    pass = Devise.friendly_token[8,20]
    email = attributes['email'] || "#{attributes['id']}-email@#{provider || 'fakemailw'}.com"

    User.find_by(email: email) || User.create!(
        email: email,
        password: pass,
        password_confirmation: pass,
        name: (attributes['name'] || [attributes['first_name'], attributes['last_name']].join(' ')).tr('^A-Za-zА-юа-ю', '')
    )
  end

  def self.get_provider_attributes(provider, token)
    case provider
      when 'facebook'
        @result = facebook(token).get_object('me',fields: 'email, last_name, first_name, id, link')
        @result['avatar'] = get_img(facebook(token).get_picture(@result['id']))
        connections = facebook(token).get_connection('me', 'friends')
        @result['friends'] = connections.raw_response['summary']['total_count'] if connections.present?
    end
    @result
  end
end