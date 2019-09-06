# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration' do
  client = Mysql2::Client.new(
    host: ENV.fetch('UNITEDWAYDB_HOST'),
    username: ENV.fetch('UNITEDWAYDB_ADMIN_USERNAME'),
    password: ENV.fetch('UNITEDWAYDB_ADMIN_PASSWORD'),
    database: ENV.fetch('UNITEDWAYDB_DATABASE')
  )

  before(:each) do
    case_id = 7342
    cellphonenumber = '5551239876'
    
    EventCursor.create(key: 'document_assigned_event', time: Time.now - 1.day)

    insert_statement = <<-SQL
      INSERT INTO document_assigned_index(
        ClientID,
        DocType,
        ReceivedDate,
        CallerID,
        ExportDate,
        ExportTime,
        Source,
        DocID
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
    SQL

    insert_command = client.prepare(insert_statement)
    document_datetime = Time.now + 1.second
    document_date = document_datetime.to_date
    document_time = document_datetime.strftime("%H:%M:%S")
    insert_command.execute(
      case_id,
      'doc type 1',
      document_date,
      cellphonenumber,
      document_date,
      document_time,
      'test',
      12345
    )
    insert_command.execute(
      case_id,
      'doc type 2',
      document_date,
      cellphonenumber,
      document_date,
      document_time,
      'test',
      12345
    )

    Parent.create(caseid: case_id, cellphonenumber: cellphonenumber, active: true)
  end

  context 'parent is active' do
    it 'sends notifications' do
      NotificationRunner.schedule_notifications(sender: FakeSender)
      expect(FakeSender.messages.size).to eq 2
    end
  end

  context 'parent is inactive' do
    it 'does not send notifications' do
      parent = Parent.first
      parent.active = false
      parent.save
      NotificationRunner.schedule_notifications(sender: FakeSender)
      expect(FakeSender.messages.size).to eq 0 
    end
  end

  after(:each) do
    client.query('DELETE FROM document_assigned_index')
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