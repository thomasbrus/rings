require 'set'
require 'forwardable'

module Rings
  class WaitingQueue
    extend Forwardable
    def_delegators :queue, :clear, :each
    def_delegator :queue, :delete, :dequeue
    def_delegator :queue, :add, :enqueue    

    @@queues = Hash.new

    def initialize size
      @@queues[size] ||= Set.new
      @size = size
    end

    def self.withdraw item
      @@queues.values.each { |queue| queue.delete item }
    end

    def ready?
      queue.size >= @size
    end

    private 
    def queue
      @@queues[@size]
    end
  end
end