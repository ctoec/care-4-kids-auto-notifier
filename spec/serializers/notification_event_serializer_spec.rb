require 'rails_helper'

RSpec.describe NotificationEventSerializer do
  it 'compose of serialization and deserialization is identity function' do
    notification_event = NotificationEvent.new("123", 3) # caseid, notificationid
    expect(
      NotificationEventSerializer.deserialize(
        NotificationEventSerializer.serialize(
          notification_event
        )
      )
    ).to eq notification_event
  end
end
