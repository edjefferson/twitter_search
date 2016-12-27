require 'csv'
require_relative 'filename'
require_relative 'page'

class TwitterSearch
  attr_accessor :cursor, :finished, :filename
  def initialize search_term, start_date, end_date
    @finished = 0
    @tweet_count = 0
    @cursor = ""
    @filename = Filename.new(search_term, start_date, end_date).name
    CSV.open("#{filename}.csv", "w")
    while @finished == 0
      page = Page.new search_term, start_date, end_date, self
      @cursor = page.cursor
      @tweet_count += 20
      print "Collected #{@tweet_count} tweets mentioning \"#{search_term}\"\r"
    end
    puts "Collected #{@tweet_count} tweets mentioning \"#{search_term}\""
  end
  
end


