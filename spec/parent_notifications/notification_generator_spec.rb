# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationGenerator do
  describe 'fetch_all_new' do
    context 'there is an event that matches a parent' do
      it 'returns a notification event with the correct case id' do
        caseid = (rand 100).to_s
        document_assigned_events = build_document_assigned_events_stub(
          parents: [Parent.create(caseid: caseid, cellphonenumber: '+5555555555')]
        )

        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.first.caseid).to eql caseid
      end

      it 'returns a notification event with a notification id that is linked stored notification with message text' do
        caseid = (rand 100).to_s
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: caseid, cellphonenumber: '+5555555555')
          ]
        )
        notification_generator = NotificationGenerator.new(
          document_assigned_events: document_assigned_events
        )

        notification_events = fetch_all_new notification_generator
        stored_notification = Notification.last
        expect(stored_notification.message_text).to eql 'We have received document some doc'
      end
    end

    context 'there are multiple events that have corresponding parents' do
      it 'returns all the notification events' do
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: 'x', cellphonenumber: '+5555555555'),
            Parent.create(caseid: 'y', cellphonenumber: '+5555555555')
          ]
        )
        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 2
      end
    end

    context 'there are multiple events and some do not have a corresponding parents' do
      it 'returns only the notification events that correspond to a parent' do
        Parent.create(caseid: 'x', cellphonenumber: '+5555555555')
        parents = [
          Parent.create(caseid: 'y', cellphonenumber: '+5555555555')
        ]
        document_assigned_events = build_document_assigned_events_stub(parents: parents)

        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 1
      end
    end
  end
end

def fetch_all_new(notification_generator)
  notification_events = []
  notification_generator.fetch_all_new { |n| notification_events.push n }
  notification_events
end

def build_document_assigned_events_stub(parents:)
  document_assigned_events = double
  events = parents.map do |parent|
    DocumentAssignedEvent.new(parent.caseid, 'some doc', Time.now)
  end
  allow(document_assigned_events).to receive(:fetch_all_new).and_return events
  document_assigned_events
end
