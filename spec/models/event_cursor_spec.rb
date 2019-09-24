# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventCursor do
  it 'does not allow the creation of more than one EventCursor with the same key' do
    EventCursor.create(key: 'test', time: Time.now)
    second_cursor = EventCursor.new(key: 'test', time: Time.now)
    expect(second_cursor.save).to eq false
  end
end
