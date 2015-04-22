class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.create_from_omniauth(params, user, provider)
    create(
      user: user,
      provider: provider,
      uid: params['uid'],
      accesstoken: params['credentials']['token'],
      refreshtoken: params['credentials']['refresh_token'],
      name: params['info']['name'],
      email: params['info']['email'],
      nickname: params['info']['nickname'],
      phone: params['info']['phone']
    )
  end

end