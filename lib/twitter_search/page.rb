require 'json'
require 'net/http'
require 'nokogiri'
require_relative 'tweet'

class Page
  attr_accessor :cursor, :tweets
  def initialize search_term, start_date, end_date, twitter_search
    output = parse_twitter_json(search_term, start_date, end_date, twitter_search.cursor)
    @cursor = output["min_position"]
    @tweets = extract_tweets(output["items_html"]).map {|tweet| Tweet.new(tweet, twitter_search)}
    is_search_finished? twitter_search
  end
  
  def parse_twitter_json search_term, start_date, end_date, cursor
    json_url = "https://twitter.com/i/search/timeline?f=tweets&vertical=default&q=%22#{search_term}%22%20since%3A#{start_date}%20until%3A#{end_date}&src=typd&include_available_features=1&max_position=#{cursor}&include_entities=1&reset_error_state=false"
    response = Net::HTTP.get(URI(json_url))
    return JSON.parse(response)
  end
  
  def extract_tweets tweet_html
    html_doc = Nokogiri::HTML(tweet_html)
    return html_doc.css('li/div.tweet')
  end

  def is_search_finished? twitter_search
    self.tweets.size == 0 ? twitter_search.finished = 1 : nil
  end
end