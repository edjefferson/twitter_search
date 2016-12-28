require 'csv'
require_relative 'filename'
require_relative 'page'
require 'time'

class TwitterSearch
  attr_accessor :cursor, :finished, :filename, :tweet_count, :resume_date_ids
  def initialize search_term, start_date, end_date
    @finished = 0
    @tweet_count = 0
    @cursor = ""
    @resume_date_ids = []
    @filename = Filename.new(search_term, start_date, end_date).name
    resume_check == 1 ? end_date = resume_date : nil
    
    while self.finished == 0
      page = Page.new search_term, start_date, end_date, self
      self.cursor = page.cursor
      self.tweet_count += 20
      print "Collected #{@tweet_count} tweets mentioning \"#{search_term}\"\r"
    end
    puts "Collected #{@tweet_count} tweets mentioning \"#{search_term}\""
  end
  
  def resume_check
    check = File.file?("#{self.filename}.csv") ? 1 : 0
    check == 0 ? CSV.open("#{self.filename}.csv", "w") : nil
    puts check
    return check
  end  
  
  def resume_date
    times = []
    CSV.foreach("#{self.filename}.csv") do |row|
      self.tweet_count += 1
      times << row[4]
    end
    last_date = Time.parse(times[-1])
    last_date_plus_one = (last_date + 86400).strftime("%Y-%m-%d")
    CSV.foreach("#{self.filename}.csv") do |row|
      Time.parse(row[4]).strftime("%Y-%m-%d") == last_date.strftime("%Y-%m-%d") ? self.resume_date_ids << row[0] : nil
    end
    return last_date_plus_one
  end
end


