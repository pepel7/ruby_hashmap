require_relative './lib/hash_map'

test = HashMap.new

# p test.buckets
# puts "\n"
# p "capacity: #{test.capacity}"
# puts "\n"
# p test.set('marina', 'cool')
# p test.buckets
# puts "\n"
# p test.set('karen', 'nice')
# puts "\n"
# p test.buckets

test.set('marina', 'cool')
test.set('karen', 'nice')

p test.get('karina')
p test.get('karen')
