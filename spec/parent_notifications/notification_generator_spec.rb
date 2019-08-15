require 'rails_helper'

RSpec.describe NotificationGenerator do
    describe 'fetch_last_hour' do

        context 'there is an event that matches a parent' do 
            it 'returns a notification event with the correct case id' do
                caseid = (rand 100).to_s  
                docuclass_events = build_docuclass_events_stub(parents: [
                    Applicant.create(caseid: caseid, cellphonenumber: '+5555555555')
                ])
                
                notification_generator = NotificationGenerator.new docuclass_events: docuclass_events
                
                notification_events = fetch_all_last_hour notification_generator
                expect(notification_events.first.caseid).to eql caseid
            end

            it 'returns a notification event with a notification id that is linked stored notification with message text' do
                caseid = (rand 100).to_s  
                docuclass_events = build_docuclass_events_stub(parents: [
                    Applicant.create(caseid: caseid, cellphonenumber: '+5555555555')
                ])
                notification_generator = NotificationGenerator.new docuclass_events: docuclass_events
                
                notification_events = fetch_all_last_hour notification_generator
                notificationid = notification_events.first.notificationid
                stored_notification = Notification.last
                expect(stored_notification.message_text).to eql "We have received document some doc"
            end
        end

        context 'there are multiple events that have corresponding parents' do 
            it 'returns all the notification events' do
                docuclass_events = build_docuclass_events_stub(parents: [
                    Applicant.create(caseid: 'x', cellphonenumber: '+5555555555'),
                    Applicant.create(caseid: 'y', cellphonenumber: '+5555555555')
                ])
                notification_generator = NotificationGenerator.new docuclass_events: docuclass_events
                
                notification_events = fetch_all_last_hour notification_generator
                expect(notification_events.length).to eql 2
            end
        end 

        context 'there are multiple events and some do not have a corresponding parents' do 
            it 'returns only the notification events that correspond to a parent' do
                Applicant.create(caseid: 'x', cellphonenumber: '+5555555555')
                docuclass_events = build_docuclass_events_stub(parents: [
                    Applicant.create(caseid: 'y', cellphonenumber: '+5555555555')
                ])

                notification_generator = NotificationGenerator.new docuclass_events: docuclass_events

                notification_events = fetch_all_last_hour notification_generator
                expect(notification_events.length).to eql 1
            end
        end
    end
end

def fetch_all_last_hour(notification_generator)
    notification_events = []
    notification_generator.fetch_last_hour {|n| notification_events.push n}
    notification_events
end

def build_docuclass_events_stub(parents:)
    docuclass_events = double
    events = parents.map do |parent|
        DocuclassEvent.new('some doc', parent.caseid)
    end
    allow(docuclass_events).to receive(:fetch_last_hour).and_return events
    return docuclass_events
end