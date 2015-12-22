$twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["twitter_app_id"]
  config.consumer_secret     = ENV["twitter_app_secret"]
  config.access_token        = ENV["twitter_access_app_id"]
  config.access_token_secret = ENV["twitter_access_app_secret"]
end