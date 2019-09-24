# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventCursor do
  it 'does not allow the creation of more than one EventCursor' do
    EventCursor.create(key: 'document_assigned_event', time: Time.now)
    second_cursor = EventCursor.create(key: 'document_assigned_event', time: Time.now)
    puts second_cursor
  end
end
