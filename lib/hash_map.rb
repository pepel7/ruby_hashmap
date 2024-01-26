require './lib/linked_list'

class HashMap
  attr_reader :buckets, :capacity

  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(16) { LinkedList.new }
    @capacity = buckets.length
  end

  def set(key, value)
    grow_buckets if almost_full?

    index = get_index(key)
    buckets[index].append([key, value])
  end
  alias []= set

  def get(key)
    index = get_index(key)
    return nil if buckets[index].empty?

    buckets[index].find_enum { |node| node.value[0] == key }.value[1]
  end
  alias [] get

  # Checks whether the key is in the hash map.
  def key?(key)
    !!get(key)
  end

  def remove(key)
    index = get_index(key)
    return nil if buckets[index].empty?

    buckets[index].each do |node, i|
      break buckets[index].remove_at(i) if node.value[0] == key
    end
  end

  def length
    buckets.sum(&:size)
  end

  def clear
    initialize
  end

  def keys
    collect_all { |node| node.value[0] }
  end

  def values
    collect_all { |node| node.value[1] }
  end

  def entries
    collect_all(&:value)
  end

  private

  def hash(key)
    return 'Error: only strings are supported.' unless key.is_a?(String)

    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def grow_buckets
    old_entries = entries
    @buckets = Array.new(capacity * 2) { LinkedList.new }
    @capacity = buckets.length

    old_entries.each { |key, value| set(key, value) }
  end

  def almost_full?
    filled_buckets = length
    filled_percentage = filled_buckets / capacity.to_f
    filled_percentage >= LOAD_FACTOR
  end

  def get_index(key)
    index = hash(key) % capacity
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  # Collects all things you pass.
  def collect_all
    buckets.each_with_object([]) do |bucket, all|
      next all if bucket.empty?

      bucket.each do |node|
        all << yield(node)
      end
    end
  end
end
