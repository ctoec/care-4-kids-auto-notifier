# frozen_string_literal: true

class FakeSender
  @@messages = []
  
  def self.messages
    @@messages
  end

  def self.createMessage(message_text:, to_number:)
    @@messages << "A message with the next: \"#{message_text}\" was sent to #{to_number}."
  end
end
