class LinkedList
  attr_reader :head

  def prepend(value)
    @head = Node.new(value, @head)
    self
  end

  def append(value)
    return prepend(value) if size.zero?

    tail.next_node = Node.new(value)
    self
  end

  def size
    cursor = head
    count = 0
    until cursor.nil?
      cursor = cursor.next_node
      count += 1
    end
    count
  end

  def empty?
    self.size.zero?
  end

  # returns the last node
  def tail
    return nil if size.zero?

    cursor = head
    cursor = cursor.next_node until cursor.next_node.nil?
    cursor
  end

  def at(index)
    return nil if index >= size

    cursor = head
    index.times do
      cursor = cursor.next_node
    end
    cursor
  end

  def pop
    return 'error: the list is empty' if size.zero?

    cursor = head
    cursor = cursor.next_node until cursor.next_node.next_node.nil?
    popped = cursor.next_node
    cursor.next_node = nil
    popped
  end

  def contains?(value)
    cursor = head
    until cursor.nil?
      return true if cursor.value == value

      cursor = cursor.next_node
    end
    false
  end

  def find(value)
    cursor = head
    index = 0
    until cursor.nil?
      return index if cursor.value == value

      cursor = cursor.next_node
      index += 1
    end
  end

  def each
    cursor = head
    index = 0
    until cursor.nil?
      yield(cursor)

      cursor = cursor.next_node
      index += 1
    end
    self
  end

  def find_enum
    self.each { |node| break node if yield(node) }
  end

  def to_s
    cursor = head
    string = ''
    until cursor.nil?
      string += "( #{cursor.value} ) -> "
      cursor = cursor.next_node
    end
    string + 'nil'
  end

  def insert_at(value, index)
    return 'error: the list is shorter than the given index' if index > size
    return prepend(value) if index.zero?
    return append(value) if index == size

    cursor = head
    (index - 1).times do
      cursor = cursor.next_node
    end
    rest = cursor.next_node
    cursor.next_node = Node.new(value, rest)
    self
  end

  def remove_at(index)
    return 'error: the list is shorter than the given index' if index >= size
    return 'error: there is nothing to remove in the list' if size.zero?
    return pop(index) if index == size - 1

    cursor = head
    (index - 1).times do
      cursor = cursor.next_node
    end
    rest = cursor.next_node.next_node
    cursor.next_node = rest
    self
  end
end

class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end
