# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration' do
  before(:each) do
    case_id = '7342'
    cellphonenumber = '+15551239876'
    
    EventCursor.create(key: 'document_assigned_event', time: Time.now - 1.day)

    client = Mysql2::Client.new(
      host: ENV.fetch('UNITEDWAYDB_HOST'),
      username: ENV.fetch('UNITEDWAYDB_ADMIN_USERNAME'),
      password: ENV.fetch('UNITEDWAYDB_ADMIN_PASSWORD'),
      database: ENV.fetch('UNITEDWAYDB_DATABASE')
    )
    insert_statement = 'INSERT INTO document_assigned_index(caseid, document_type, index_date) VALUES (?, ?, ?);'

    insert_command = client.prepare(insert_statement)
    insert_command.execute(case_id, 'doc type 2', Time.now)
    insert_command.execute(case_id, 'doc type 1', Time.now)

    Parent.create(caseid: case_id, cellphonenumber: cellphonenumber)
  end

  it 'sends notifications' do
    NotificationRunner.schedule_notifications(sender: FakeSender)
    expect(FakeSender.messages.size).to eq 2
  end

  after(:each) do
    client = Mysql2::Client.new(
      host: ENV.fetch('UNITEDWAYDB_HOST'),
      username: ENV.fetch('UNITEDWAYDB_ADMIN_USERNAME'),
      password: ENV.fetch('UNITEDWAYDB_ADMIN_PASSWORD'),
      database: ENV.fetch('UNITEDWAYDB_DATABASE')
    )
    delete_statement = 'DELETE FROM document_assigned_index'

    client.prepare(delete_statement).execute
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
end