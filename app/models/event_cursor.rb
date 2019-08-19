class EventCursor < ApplicationRecord
  def self.update_last_document_assigned_events(time:)
    find_by(key: 'document_assigned_event').update(time: time)
  end

  def self.fetch_last_document_assigned_events
    find_by(key: 'document_assigned_event').time.iso8601
  end
end
