class Filename
  attr_accessor :name
  def initialize search_term, start_date, end_date
    @name = sanitize("#{search_term}_#{start_date}_#{end_date}")
  end
  
  def sanitize(filename)
    bad_chars = [ '/', '\\', '?', '%', '*', ':', '|', '"', '<', '>', '.', ' ' ]
    bad_chars.each do |bad_char|
      filename.gsub!(bad_char, '_')
    end
    filename
  end
end