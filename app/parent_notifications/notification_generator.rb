# frozen_string_literal: true

class NotificationGenerator
  def initialize(document_assigned_events:)
    @document_assigned_events = document_assigned_events
  end

  def fetch_all_new
    @document_assigned_events.fetch_all_new.each do |event|
      found_parent = Parent.where(caseid: event.caseid).first
      yield build_notification_event(event: event) if parent_is_active(found_parent)
    end
  end

  def build_notification_event(event:)
    notification = Notification.create(
      message_text: build_document_received_message(
        type: event.type, source: event.source, date: event.date
      )
    )
    NotificationEvent.new(event.caseid, notification.id)
  end

  def parent_is_active(parent)
    !parent.nil? and parent.active
  end
  
  def build_document_received_message(type:, source:, date:)
    <<-string.gsub(/\s+/, " ").strip
      This is Care 4 Kids!
      We have received your #{type}
      by #{source}
      on #{date.strftime('%m/%d/%Y')}.
      You will be notified if there is any missing information.
    string
  end
end
