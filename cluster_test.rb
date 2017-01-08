#!/usr/bin/ruby
require "./cluster"
data = Array.new(100) { |num|
    { "name" => "person"+num.to_s,
    "CC" => num + num*(num/90) }
}

data.each { |value|
    puts value["name"] + "     " + value["CC"].to_s
}

puts
puts

kcluster3(data, "CC" ).each { |value|
    puts value["name"] + "     " + value["CC"].to_s
}
