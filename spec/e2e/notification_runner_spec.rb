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

    date = Time.new(2010, 1, 1, 9, 0, 0)

    EventCursor.delete_all
    EventCursor.create(key: 'document_assigned_event', time: date - 1.day)

    document_datetime = date + 1.minutes
    document_date = document_datetime.to_date
    document_time = document_datetime.strftime("%H:%M:%S")
     write_client.insert(
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

    write_client.insert(
      doc_id: 2,
      typeId: SQLServerClient::EMAILS,

      archivedAt: document_datetime,
      deleted: nil,
      client_id: case_id,
      c17: '5551239876',
      doc_type: 'RP - Redetermination',

      instanceId: 2,

      dateEntered: document_date,
      timeEntered: document_time
    )

    Parent.create(caseid: case_id, cellphonenumber: cellphonenumber, active: true, notifications_generated_count: 1)
  end

  it 'sends notifications' do
    NotificationRunner.schedule_notifications(sender: FakeSender, scheduler: ImmediateScheduler)
    expect(FakeSender.messages.size).to eq 2
    expect(FakeSender.messages[0]).to include(
      <<-string.gsub(/\s+/, " ").strip
        This is Care 4 Kids!
        We have received your redetermination by fax on 01/01/2010.
        You will be notified if there is any missing information.
      string
    )
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
    @@messages << "A message with the text: \"#{message_text}\" was sent to #{to_number}."
  end

  def self.reset
    @@messages = []
  end
end
