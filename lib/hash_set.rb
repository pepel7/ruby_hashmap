require './lib/linked_list'

class HashSet
  attr_reader :buckets, :capacity, :load_factor

  def initialize
    @buckets = Array.new(16) { LinkedList.new }
    @capacity = buckets.length
    @load_factor = 0.75
  end

  def set(key)
    grow_buckets if almost_full?

    index = get_index(key)
    buckets[index].append(key)
  end

  def get(key)
    index = get_index(key)
    return nil if buckets[index].empty?

    buckets[index].find_enum { |node| node.value == key }.value
  end

  # Checks whether the key is in the hash set.
  def key?(key)
    !!get(key)
  end

  def remove(key)
    index = get_index(key)
    return nil if buckets[index].empty?

    buckets[index].each do |node, i|
      break buckets[index].remove_at(i) if node.value == key
    end
  end

  def length
    buckets.sum(&:size)
  end

  def clear
    initialize
  end

  def keys
    buckets.each_with_object([]) do |bucket, all|
      next all if bucket.empty?

      bucket.each do |node|
        all << node.value
      end
    end
  end

  private

  def hash(key)
    return 'Error: only strings are supported.' unless key.is_a?(String)

    hash_code = 0
    prime_number = 31

    string.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def almost_full?
    filled_buckets = length
    filled_percentage = filled_buckets / capacity.to_f
    filled_percentage >= LOAD_FACTOR
  end

  def grow_buckets
    old_buckets = buckets
    new_buckets = Array.new(capacity * 2) { LinkedList.new }

    old_buckets.each_with_index do |bucket, index|
      next if bucket.empty?

      new_buckets[index] = bucket
    end

    @buckets = new_buckets
    @capacity = buckets.length
  end

  def get_index(key)
    index = hash(key) % capacity
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end
end
