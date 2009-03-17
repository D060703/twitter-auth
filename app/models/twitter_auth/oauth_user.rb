module TwitterAuth
  class OauthUser < TwitterAuth::GenericUser 
    def self.identify_or_create_from_access_token(token, secret=nil)
      raise ArgumentError, 'Must authenticate with an OAuth::AccessToken or the string access token and secret.' unless (token && secret) || token.is_a?(OAuth::AccessToken)

      user_info = JSON.parse(token.get('/account/verify_credentials.json').body)

      if user = User.find_by_login(user_info['screen_name'])
        user.update_twitter_attributes(user_info)
        user
      else
        User.create_from_twitter_hash_and_token(user_info, token) 
      end
    end

    def self.create_from_twitter_hash_and_token(user_info, access_token)
      user = User.new_from_twitter_hash(user_info)
      user.access_token = access_token.token
      user.access_secret = access_token.secret
      user.save
      user
    end
  end
end
