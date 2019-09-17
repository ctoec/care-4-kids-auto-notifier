# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationGenerator do
  describe 'fetch_all_new' do
    context 'there is an event that matches an active parent' do
      it 'returns a notification event with the correct case id' do
        time = Time.new(2010,1,1,0,0,0)
        caseid = (rand 100).to_s
        document_assigned_events = build_document_assigned_events_stub(
          parents: [Parent.create(caseid: caseid, cellphonenumber: '+5555555555', active: true)],
          time: time
        )

        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.first.caseid).to eql caseid
      end

      it 'returns a notification event with a notification id that is linked stored notification with message text' do
        time = Time.new(2010,1,1,0,0,0)
        caseid = (rand 100).to_s
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: caseid, cellphonenumber: '+5555555555', active: true, notifications_generated_count: 1)
          ],
          time: time
        )
        notification_generator = NotificationGenerator.new(
          document_assigned_events: document_assigned_events
        )

        notification_events = fetch_all_new notification_generator
        stored_notification = Notification.last
        expect(stored_notification.message_text).to eql 'This is Care 4 Kids! We have received your some doc by fax on 01/01/2010. You will be notified if there is any missing information.'
      end

      it 'generates a message reminding the recipient of the instructions if they are receiving their first message' do
        caseid = (rand 100).to_s
        time = Time.new(2010,1,1,0,0,0)
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: caseid, cellphonenumber: '+5555555555', active: true)
          ],
          time: time
        )
        notification_generator = NotificationGenerator.new(
          document_assigned_events: document_assigned_events
        )

        notification_events = fetch_all_new notification_generator
        stored_notification = Notification.last
        expect(stored_notification.message_text).to eql "You can text STATUS for information on Care 4 Kids processing dates. Questions or feedback about these notifications? Text QUESTION anytime to retrieve this link: http://bit.ly/Care4KidsPilot. Text REMOVE to stop participating in the pilot program and receiving notifications."
      end

      it 'does not generate a message reminding the recipient of the instructions if they are not receiving their first message' do
        caseid = (rand 100).to_s
        time = Time.new(2010,1,1,0,0,0)
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: caseid, cellphonenumber: '5555555555', active: true, notifications_generated_count: 1)
          ],
          time: time
        )
        notification_generator = NotificationGenerator.new(
          document_assigned_events: document_assigned_events
        )

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 1
      end
    end

    context 'there are multiple events that have corresponding active parents' do
      it 'returns all the notification events' do
        time = Time.new(2010,1,1,0,0,0)
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: 'x', cellphonenumber: '+5555555555', active: true, notifications_generated_count: 1),
            Parent.create(caseid: 'y', cellphonenumber: '+5555555555', active: true, notifications_generated_count: 1)
          ],
          time: time
        )
        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 2
      end
    end

    context 'there are multiple events and some do not have active corresponding parents' do
      it 'returns only the notification events that correspond to a parent' do
        time = Time.new(2010,1,1,0,0,0)
        Parent.create(caseid: 'x', cellphonenumber: '+5555555555', active: true)
        parents = [
          Parent.create(caseid: 'y', cellphonenumber: '+5555555555', active: true, notifications_generated_count: 1)
        ]
        document_assigned_events = build_document_assigned_events_stub(
          parents: parents,
          time: time
        )

        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 1
      end
    end

    context 'there is an event that matches an inactive parent' do
      it 'returns no notification events' do
        caseid = (rand 100).to_s
        time = Time.new(2010,1,1,0,0,0)
        document_assigned_events = build_document_assigned_events_stub(
          parents: [Parent.create(caseid: caseid, cellphonenumber: '+5555555555', active: false)],
          time: time
        )

        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 0
      end
    end

    context 'there are multiple events that have corresponding inactive parents' do
      it 'returns no notification events' do
        time = Time.new(2010,1,1,0,0,0)
        document_assigned_events = build_document_assigned_events_stub(
          parents: [
            Parent.create(caseid: 'x', cellphonenumber: '+5555555555', active: false),
            Parent.create(caseid: 'y', cellphonenumber: '+5555555555', active: false)
          ],
          time: time
        )
        notification_generator = NotificationGenerator.new document_assigned_events: document_assigned_events

        notification_events = fetch_all_new notification_generator
        expect(notification_events.length).to eql 0
      end
    end

    context 'there are multiple events and some have active corresponding parents' do
      it 'returns only the notification events that correspond to an active parent' do
        time = Time.new(2010,1,1,0,0,0)
        Parent.create(caseid: 'x', cellphonenumber: '+5555555555', active: false)
        parents = [
          Parent.create(caseid: 'y', cellphonenumber: '+5555555555', active: true, notifications_generated_count: 1)
        ]
        document_assigned_events = build_document_assigned_events_stub(
          parents: parents,
          time: time
        )

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

def build_document_assigned_events_stub(parents:, time:)
  document_assigned_events = double
  events = parents.map do |parent|
    DocumentAssignedEvent.new(parent.caseid, 'some doc', 'fax', time)
  end
  allow(document_assigned_events).to receive(:fetch_all_new).and_return events
  document_assigned_events
end
