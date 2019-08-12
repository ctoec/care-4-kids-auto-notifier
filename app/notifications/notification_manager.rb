# frozen_string_literal: true

class NotificationManager
  def initialize(message_queue:, message_generator:)
    @message_queue = message_queue
    @message_generator = message_generator
  end

  def run
    @message_generator.each { |message| @message_queue.put message }
  end
end
