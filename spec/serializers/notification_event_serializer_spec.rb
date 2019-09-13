# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationEventSerializer do
  it 'compose of serialization and deserialization is identity function' do
    notification_event = NotificationEvent.new('123', 3)
    deserialized_notification_event = NotificationEventSerializer.deserialize(
      NotificationEventSerializer.serialize(
        notification_event
      )
    )
    expect(
      deserialized_notification_event.caseid
    ).to eq notification_event.caseid
    expect(
      deserialized_notification_event.notificationid
    ).to eq notification_event.notificationid
  end
end
