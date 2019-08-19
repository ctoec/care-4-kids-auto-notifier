# frozen_string_literal: true

class NotificationManager
  def initialize(message_queue:, notification_generator:)
    @message_queue = message_queue
    @notification_generator = notification_generator
  end

  def run
    @notification_generator.fetch_new { |message| @message_queue.put message }
  end
end
