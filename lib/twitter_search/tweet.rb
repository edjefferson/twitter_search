require 'nokogiri'
require 'csv'

class Tweet
  def initialize tweet, filename
    @text = tweet.css('div.js-tweet-text-container/p').inner_text
    @id = tweet.attribute("data-tweet-id").to_s
    @screen_name = tweet.attribute("data-screen-name").to_s
    @name = tweet.attribute("data-name").to_s
    @time = Time.at(tweet.css('a.tweet-timestamp/span').attribute("data-time").to_s.to_i)
    @permalink = "http://www.twitter.com#{tweet.attribute("data-permalink-path")}"
    self.output_to_csv(filename)
  end
  
  def values
    return self.instance_variables.map {|variable| self.instance_variable_get(variable)}
  end
  
  def output_to_csv filename
    CSV.open("#{filename}.csv", "a") {|csv| csv << self.values}
  end
end