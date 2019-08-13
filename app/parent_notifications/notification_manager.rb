# frozen_string_literal: true

class NotificationManager
  def initialize(message_queue:, indexed_documents:)
    @message_queue = message_queue
    @indexed_documents = indexed_documents
  end

  def run
    @indexed_documents.fetch_last_hour { |message| @message_queue.put message }
  end
end
