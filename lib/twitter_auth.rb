module TwitterAuth
  mattr_accessor :base_url
  self.base_url = 'https://twitter.com'
  
  def self.config(environment=RAILS_ENV)
    YAML.load(File.open(RAILS_ROOT + '/config/twitter_auth.yml').read)[environment]
  end

  # The authentication strategy employed by this
  # application. Set in +config/twitter.yml+ as
  # strategy; valid options are oauth or basic.
  def self.strategy
    strat = config['strategy']
    raise ArgumentError, 'Invalid TwitterAuth Strategy: Valid strategies are oauth and basic.' unless %w(oauth basic).include?(strat)
    strat.to_sym
  end

  def self.oauth?
    strategy == :oauth
  end

  def self.basic?
    strategy == :basic
  end
  
  # The OAuth consumer used by TwitterAuth for authentication. The consumer key and secret are set in your application's +config/twitter.yml+
  def self.consumer
    OAuth::Consumer.new(
      config['oauth_consumer_key'],          
      config['oauth_consumer_secret'],
      :site => TwitterAuth.base_url
    )
  end
end

require 'twitter_auth/controller_extensions'
