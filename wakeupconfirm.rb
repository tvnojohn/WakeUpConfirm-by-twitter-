#encoding: utf-8
require 'rubygems'
require 'twitter'
require 'gmail'

#tweet
consumer_key = "YOUR_CONSUMER_KEY"
consumer_secret = "YOUR_CONSUMER_SECRET"
access_token = "YOUR_ACCESS_TOKEN"
access_token_secret= "YOUR_ACCESS_SECRET"

config = {
	consumer_key: consumer_key,
	consumer_secret: consumer_secret,
	access_token: access_token,
	access_token_secret: access_token_secret
}

$client = Twitter::REST::Client.new(config)

#gmail
USERNAME = "GMAIL_ADRESS"
PASSWORD = "GMAIL_APPLI_PASSWORD"

gmail = Gmail.new(USERNAME, PASSWORD)

#twitter_id
myid = $client.user.id

#tweet_time
def tweet_id2time(id)
	case id
 	when Integer
		Time.at(((id.to_i >> 22) + 1288834974657) / 1000.0)
	else
		nil
	end
end

#last_tweet
$client.user_timeline(myid, { count: 1 }).each do |tweet|
	tweetime = tweet_id2time(tweet.id)
    if tweetime > Time.now - 7200 #before 2hour
		puts "起きてます"
	else
		message =
				gmail.generate_message do
		   	 	to "送信先アドレス"
		    	subject "test"
			 	html_part do
			 	 	content_type "text/html; charset=UTF-8"
			   		body "<h1>まだ家で寝てます！！</h1>"
				end 
		end 
		gmail.deliver(message)
		gmail.logout
	end
end
