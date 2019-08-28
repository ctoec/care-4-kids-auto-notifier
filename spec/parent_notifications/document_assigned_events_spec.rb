# frozen_string_literal: true

require 'rails_helper'

INSERT_STATEMENT = <<-SQL
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

RSpec.describe DocumentAssignedEvents do
  before(:all) do
    @client = Mysql2::Client.new(
      host: ENV.fetch('UNITEDWAYDB_HOST'),
      username: ENV.fetch('UNITEDWAYDB_ADMIN_USERNAME'),
      password: ENV.fetch('UNITEDWAYDB_ADMIN_PASSWORD'),
      database: ENV.fetch('UNITEDWAYDB_DATABASE')
    )
  end

  before(:each) do
    EventCursor.create(key: 'document_assigned_event', time: Time.now)
    @client.prepare('DELETE FROM document_assigned_index;').execute
  end

  describe 'fetch_all_new' do
    context 'there are no events' do
      it 'returns nothing' do
        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 0
      end
    end

    context 'there is one new event' do
      it 'fetches one event with the correct format' do
        EventCursor.document_assigned_events_cursor = Time.now

        insert_command = @client.prepare(INSERT_STATEMENT)
        document_datetime = Time.now + 1.second
        document_date = document_datetime.to_date
        document_time = document_datetime.strftime("%H:%M:%S")
        insert_command.execute(
          1234,
          'doc type 1',
          document_date,
          '5555555555',
          document_date,
          document_time,
          'test',
          12345
        )

        event = DocumentAssignedEvents.fetch_all_new.first
        expect(event.caseid).to eql 1234
        expect(event.type).to eql 'doc type 1'
        expect(event.date.to_s).to eql document_datetime.to_s
      end
    end

    context 'there is are multiple event' do
      it 'fetches all events' do
        current_datetime = Time.now

        future_datetime = current_datetime + 1.second
        future_date = future_datetime.to_date
        future_time = future_datetime.strftime("%H:%M:%S")

        later_future_datetime = future_datetime + 1.second
        later_future_date = later_future_datetime.to_date
        later_future_time = later_future_datetime.strftime("%H:%M:%S")

        EventCursor.document_assigned_events_cursor = current_datetime

        insert_command = @client.prepare(INSERT_STATEMENT)
        insert_command.execute(
          1234,
          'doc type 1',
          future_date,
          '5555555555',
          future_date,
          future_time,
          'test',
          12345
        )
        insert_command.execute(
          1235,
          'doc type 1',
          later_future_date,
          '5555555555',
          later_future_date,
          later_future_time,
          'test',
          12346
        )

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 2
      end
    end

    context 'there are events that did not happen in the last hour' do
      it 'fetches only the events that happened after cursor date' do
        current_datetime = Time.now

        future_datetime = current_datetime + 1.second
        future_date = future_datetime.to_date
        future_time = future_datetime.strftime("%H:%M:%S")

        earlier_datetime = current_datetime - 1.second
        earlier_date = earlier_datetime.to_date
        earlier_time = earlier_datetime.strftime("%H:%M:%S")

        EventCursor.document_assigned_events_cursor = current_datetime

        insert_command = @client.prepare(INSERT_STATEMENT)
        insert_command.execute(
          1234,
          'doc type 1',
          future_date,
          '5555555555',
          future_date,
          future_time,
          'test',
          12345
        )
        insert_command.execute(
          1235,
          'doc type 1',
          earlier_date,
          '5555555555',
          earlier_date,
          earlier_time,
          'test',
          12346
        )

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 1
      end

      it 'does not fetch events again' do
        EventCursor.document_assigned_events_cursor = Time.now - 1.hour

        insert_command = @client.prepare(INSERT_STATEMENT)
        current_datetime = Time.now
        old_datetime = current_datetime - 10.minutes
        older_datetime = current_datetime - 20.minutes
        oldest_datetime = current_datetime - 30.minutes

        insert_command.execute(
          1235,
          'doc type 1',
          old_datetime.to_date,
          '5555555555',
          old_datetime.to_date,
          (old_datetime).strftime("%H:%M:%S"),
          'test',
          12346
        )
        insert_command.execute(
          1236,
          'doc type 1',
          older_datetime.to_date,
          '5555555555',
          older_datetime.to_date,
          (older_datetime).strftime("%H:%M:%S"),
          'test',
          12347
        )
        insert_command.execute(
          2345,
          'doc type 2',
          oldest_datetime.to_date,
          '5555555555',
          oldest_datetime.to_date,
          (oldest_datetime).strftime("%H:%M:%S"),
          'test',
          12348
        )

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 3
        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 0
      end
    end
  end
end
