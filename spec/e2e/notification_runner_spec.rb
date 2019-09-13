# frozen_string_literal: true

require 'rails_helper'
require 'sqlserver_helper'

RSpec.describe 'Integration' do
  
  write_client = SQLServerClient.new
  
  before(:each) do
    write_client.setup_types_table
    write_client.clean_database

    case_id = 7342
    cellphonenumber = '5551239876'
    
    EventCursor.create(key: 'document_assigned_event', time: Time.now - 1.day)

    document_datetime = Time.now + 1.minutes
    document_date = document_datetime.to_date
    document_time = document_datetime.strftime("%H:%M:%S")
    result = write_client.insert(
        doc_id: 1,
        typeId: SQLServerClient::FAX,

        archivedAt: document_datetime,
        deleted: nil,
        client_id: case_id,
        c17: '5551239876',
        doc_type: 'RP - Redetermination',

        instanceId: 1,

        dateEntered: document_date,
        timeEntered: document_time,

      )

    result = write_client.insert(
        doc_id: 2,
        typeId: SQLServerClient::FAX,

        archivedAt: document_datetime,
        deleted: nil,
        client_id: case_id,
        c17: '5551239876',
        doc_type: 'RP - Redetermination',

        instanceId: 2,

        dateEntered: document_date,
        timeEntered: document_time,

      )

    Parent.create(caseid: case_id, cellphonenumber: cellphonenumber, active: true)
  end

  context 'parent is active' do
    it 'sends notifications' do
      NotificationRunner.schedule_notifications(sender: FakeSender)
      expect(FakeSender.messages.size).to eq 2
    end
  end

  after(:each) do
    Parent.delete_all
    FakeSender.reset
  end
end

class FakeSender
  @@messages = []
  
  def self.messages
    @@messages
  end

  def self.createMessage(message_text:, to_number:)
    @@messages << "A message with the next: \"#{message_text}\" was sent to #{to_number}."
  end

  def self.reset
    @@messages = []
  end
end