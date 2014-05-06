#!/usr/bin/env ruby

def normalize(vector)
  norm = Math.sqrt(vector.map { |i| i**2 }.inject(:+))
  vector.map{ |i| i/norm }
end

def dot_product(v1, v2)
  v1.zip(v2).map { |pair| pair.inject(1,&:*) }.inject(:+)
end

cloud = %w{
  0 0 0 0 0 3 3 9 9 9 6 0 0 0
  0 0 0 3 4 9 5 9 9 9 9 4 0 0
  0 1 2 7 5 9 5 9 9 9 9 7 1 0
  3 9 5 9 5 9 5 9 9 9 9 9 9 3
  6 9 5 9 5 9 5 9 9 9 9 9 9 6
  1 8 5 9 5 9 5 9 9 9 9 9 8 1
}.map { |i| Integer(i) }

normalized_cloud = normalize(cloud)

# puts cloud.join("")
# puts normalized_cloud.inspect
# puts dot_product(normalized_cloud, normalized_cloud)
# puts

best_matches = []

def update_best_matches(best_matches, new_elem)
  best_matches << new_elem
  best_matches.sort! { |x,y| y[:score] <=> x[:score] }
  best_matches = best_matches[0..9]
end

File.open("pi-billion.txt") do |file|
  prefix = file.read(1) # get rid of 3

  buffer = file.read(84).split("") # read '.' and next 83 chars
  buffer.map! { |i| Integer(i) rescue nil } # rescue is cos '.' isn't an integer

  offset = 0
  while (next_char = file.read(1)) do
    buffer.shift
    buffer << Integer(next_char)
    score = dot_product(normalized_cloud, normalize(buffer))
    best_matches = update_best_matches(best_matches, score: score, buffer: buffer.dup, offset: offset)
    # puts "---------------------------------------------"
    # puts "\e[H\e[2J"
    # best_matches.each_with_index {|m,i| puts "#{i+1}: #{m[:score]} (#{m[:buffer].join("")}) at offset #{m[:offset]}" }
    # sleep 0.1
    offset += 1
  end

  puts "---------------------------------------------"
  best_matches.each_with_index {|m,i| puts "#{i+1}: #{m[:score]} (#{m[:buffer].join("")}) at offset #{m[:offset]}" }
end

