class UserAuthorization < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, presence: true
  validates :uid, uniqueness: { scope: [:provider, :user_id] }
  validates :provider, inclusion: { in: User::PROVIDERS_S }

  def self.from_account(user, provider, token, secret=nil)
    attributes = token ? get_provider_attributes(provider, token, secret) : {}

    user.profile.update(remote_image_url: attributes['avatar']) unless user.image.file && user.try(:profile)
    authorization = user.user_authorizations.find_or_create_by(provider: provider)
    authorization.update_columns(token: token, secret: secret, uid: attributes['id'])
    authorization.reload
  end

  def self.from_oauth(auth)
    authorization = find_by(provider: auth['provider'], uid: auth['uid'])
    unless authorization
      user = create_user auth
      authorization =  user.user_authorizations.find_or_create_by({ provider: auth['provider'], uid: auth['uid'] })
      user.profile.update(remote_image_url: auth['info']['image']) unless user.image.file && user.try(:profile)
      user.save
    end
    authorization.user
  end


  def self.valid_user? auth
    return true if find_by(provider: auth['provider'], uid: auth['uid'])
    return false if User.find_by(login: auth['info']['nickname'])
    return true
  end

  private

  def self.create_user attributes
    User.create(
        email: "steam#{attributes['uid']}@steam.com",
        password: Devise.friendly_token[0,20],
        login: attributes['info']['nickname']
    )
  end


  def self.get_img(img)
    img.gsub('http://', 'https://') if img
  end

  def self.facebook(token)
    @facebook = Koala::Facebook::API.new(token)
  end

  def self.find_or_create_user(attributes, provider)
    pass = Devise.friendly_token[8,20]
    email = attributes['email'] || "#{attributes['id']}-email@#{provider || 'fakemailmydiscount'}.com"

    User.find_by(email: email) || User.create!(
        email: email,
        password: pass,
        password_confirmation: pass,
        name: "#{attributes['name'] || attributes['first_name']} #{attributes['last_name']}"
    )
  end

  def self.get_provider_attributes(provider, token, secret)
    case provider
    when 'facebook'
      @result = facebook(token).get_object('me',fields: 'email, last_name, first_name, id, link')
      @result['avatar'] = get_img(facebook(token).get_picture(@result['id']))
    end
    @result
  end
end
