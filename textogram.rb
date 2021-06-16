class Textogram
  def initialize(text, case_sensitive: false, special: false, order_by_count: false)
    @case_sensitive = case_sensitive
    @special = special
    @histo = generate_histogram(text)
    sorted_histo(order_by_count: order_by_count)
  end

  def generate_histogram(text)
    histo = Hash.new(0)
    text = text.downcase unless @case_sensitive # lower case by default
    text = text.gsub(/[^0-9A-Za-z]/, '') unless @special # remove special characters
    
    text.gsub(/\s+/, "").split("").each do |c|
      histo[c] += 1
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
        @histo.each do |k, v|
          output << "%s %s\n" % [k, "*" * v]
        end
    else
      output << "Textogram is currently empty."
    end
    output 
  end
end

texto = Textogram.new("HELLO World!", special: true, case_sensitive: true)
puts "Outputting hash with special and case sensitive"
puts texto.to_s
texto = Textogram.new("HELLO World!")
puts "Outputting hash sorted alphabetically"
puts texto.to_s
puts "Outputting hash sorted by value descending"
texto.sorted_histo(order_by_count: true)
puts texto.to_s

texto = Textogram.new("")
puts "Outputting empty hash"
puts texto.to_s