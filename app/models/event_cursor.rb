# frozen_string_literal: true

class EventCursor < ApplicationRecord
  validates :key, uniqueness: { case_sensitive: true }

  def self.document_assigned_events_cursor=(time)
    find_by(key: 'document_assigned_event').update(time: time)
  end

  def self.document_assigned_events_cursor
    find_by(key: 'document_assigned_event').time
  end
end
