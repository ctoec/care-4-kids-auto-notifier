require 'rails_helper'

RSpec.describe IndexedDocuments do
    it 'creates the appropriate message for a document received in docuclass' do
        caseid = Time.now.to_i  
        Applicant.new(caseid: caseid, cellphonenumber: '555-555-5555').save
        docuclass_events = double
        allow(docuclass_events).to receive(:fetch_last_hour).and_return [
            DocuclassEvent.new('some doc', caseid),
        ]
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        messages = []
        indexed_documents.fetch_last_hour {|message| messages.push message}
        expect(messages.first.text).to eql 'We have received document some doc'
        expect(messages.first.cellphonenumber).to eql '555-555-5555'
    end

    it 'generates multiple messages for a document received in docuclass' do
        Applicant.new(caseid: 'x', cellphonenumber: '555-555-5555').save
        Applicant.new(caseid: 'y', cellphonenumber: '555-555-5555').save
        docuclass_events = double
        allow(docuclass_events).to receive(:fetch_last_hour).and_return [
            DocuclassEvent.new('some doc', 'x'),
            DocuclassEvent.new('some doc', 'y'),
        ]
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        messages = []
        indexed_documents.fetch_last_hour {|message| messages.push message}
        expect(messages.length).to eql 2
    end

    it 'does not create message if parent is not the application database' do
        Applicant.new(caseid: 'x', cellphonenumber: '555-555-5555').save
        docuclass_events = double
        allow(docuclass_events).to receive(:fetch_last_hour).and_return [
            DocuclassEvent.new('some doc', 'x'),
            DocuclassEvent.new('some doc', 'y'),
        ]
        indexed_documents = IndexedDocuments.new docuclass_events: docuclass_events
        messages = []
        indexed_documents.fetch_last_hour {|message| messages.push message}
        expect(messages.length).to eql 1
    end
end