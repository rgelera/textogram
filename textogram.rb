class Textogram
  def initialize(text, case_sensitive: false, special: false, order_by_count: false, by_words: false)
    @case_sensitive = case_sensitive
    @special = special
    @by_words = by_words
    @histo = generate_histogram(text)
    sorted_histo(order_by_count: order_by_count)
  end

  def generate_histogram(text)
    histo = Hash.new(0)
    text = text.downcase unless @case_sensitive # lower case by default
    text = text.gsub(/[^0-9A-Za-z\s]/, '') unless @special # remove special characters
    
    unless @by_words
      text.gsub(/\s+/, "").split("").each do |c|
        histo[c] += 1
      end
    else
      text.split(" ").each do |w|
        histo[w] += 1
      end
    end
    return histo
  end

  def sorted_histo(order_by_count: false)
    unless order_by_count
      @histo = @histo.sort_by { |k| k }.to_h
    else
      @histo = @histo.sort_by { |k,v| v }.reverse.to_h
    end
  end

  def to_s
    output = ''
    unless @histo.empty?
        unless @by_words
          @histo.each do |k, v|
            output << "%s %s\n" % [k, "*" * v]
          end
        else
          # padding words with spaces
          max_word_length = @histo.keys.max { |a, b| a.length <=> b.length }.length
          @histo.each do |k, v|
            output << "%-#{max_word_length}s %s\n" % [k, "*" * v]
          end
        end
    else
      output << "Textogram is currently empty."
    end
    output 
  end
end

texto = Textogram.new("HELLO World!")
puts "Outputting hash sorted alphabetically"
puts texto.to_s
texto = Textogram.new("HELLO World!", special: true, case_sensitive: true)
puts "Outputting hash with special and case sensitive"
puts texto.to_s
puts "Outputting hash sorted by value descending"
texto.sorted_histo(order_by_count: true)
puts texto.to_s

texto = Textogram.new("")
puts "Outputting empty hash"
puts texto.to_s

puts "===="
puts "Outputting histogram by words"
texto = Textogram.new("HELLO World!")
puts texto.to_s

puts "Outputting histogram of textfile by words"
file = File.open("acruelenigma-paul-bourget.txt")
texto = Textogram.new(file.readlines.join, by_words: true, order_by_count: true) 
output = File.open("output.txt", "w")
output << texto.to_s
output.close