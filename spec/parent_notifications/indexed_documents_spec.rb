require 'rails_helper'

RSpec.describe IndexedDocuments do
    it 'returns a notification event with the correct case id' do
        caseid = (rand 100).to_s  
        docuclass_events = build_docuclass_events_stub(parents: [
            Applicant.create(caseid: caseid, cellphonenumber: '5555555555')
        ])
        
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        
        notification_events = fetch_all_last_hour indexed_documents
        expect(notification_events.first.caseid).to eql caseid
    end

    it 'returns a notification event with a notification id that is linked stored notification with message text' do
        caseid = (rand 100).to_s  
        docuclass_events = build_docuclass_events_stub(parents: [
            Applicant.create(caseid: caseid, cellphonenumber: '5555555555')
        ])
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        
        notification_events = fetch_all_last_hour indexed_documents
        notificationid = notification_events.first.notificationid
        stored_notification = Notification.last
        expect(stored_notification.message_text).to eql "We have received document some doc"
    end

    it 'generates multiple messages for a document received in docuclass' do
        docuclass_events = build_docuclass_events_stub(parents: [
            Applicant.create(caseid: 'x', cellphonenumber: '5555555555'),
            Applicant.create(caseid: 'y', cellphonenumber: '5555555555')
        ])
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        
        notification_events = fetch_all_last_hour indexed_documents
        expect(notification_events.length).to eql 2
    end

    it 'does not create message if parent is not the application database' do
        Applicant.create(caseid: 'x', cellphonenumber: '5555555555')
        docuclass_events = build_docuclass_events_stub(parents: [
            Applicant.create(caseid: 'y', cellphonenumber: '5555555555')
        ])

        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events

        notification_events = fetch_all_last_hour indexed_documents
        expect(notification_events.length).to eql 1
    end
end

def fetch_all_last_hour(indexed_documents)
    notification_events = []
    indexed_documents.fetch_last_hour {|n| notification_events.push n}
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