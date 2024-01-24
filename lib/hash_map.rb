require_relative './linked_list'

class HashMap
  attr_reader :buckets, :capacity, :load_factor

  def initialize
    @buckets = Array.new(16) { LinkedList.new }
    @capacity = buckets.length
    @load_factor = 0.75
  end

  # Returns index of given key, i.e. hash.
  def hash(key)
    return 'error: only strings are supported' unless key.is_a?(String)

    string_to_number(key)
  end

  # Converts a string to a number for hashing.
  def string_to_number(string)
    hash_code = 0
    prime_number = 31

    string.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  # Adds a new value for the key.
  def set(key, value)
    filled_buckets_percentage = get_filled_buckets_percentage
    grow_buckets if filled_buckets_percentage >= load_factor

    index = hash(key) % capacity
    buckets[index].append(value)
  end

  # rubocop:disable Naming/AccessorMethodName

  # Calculates percentage of filled buckets.
  def get_filled_buckets_percentage
    filled_buckets = buckets.filter { |b| !b.empty? }.length
    p "filled_buckets: #{filled_buckets}"

    # divide by 100 at the end to preserve the style of the load factor
    (filled_buckets / capacity.to_f * 100) / 100
  end
  # rubocop:enable Naming/AccessorMethodName

  # Increases the hash map capacity by 2.
  def grow_buckets
    old_buckets = buckets
    new_buckets = Array.new(capacity * 2) { LinkedList.new }

    old_buckets.each_with_index do |bucket, index|
      next if bucket.size.nil?

      new_buckets[index] = bucket
    end

    @buckets = new_buckets
    @capacity = buckets.length
  end
end
