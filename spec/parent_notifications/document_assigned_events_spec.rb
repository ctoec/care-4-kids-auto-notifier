# frozen_string_literal: true

require 'rails_helper'

INSERT_STATEMENT = 'INSERT INTO document_assigned_index(caseid, document_type, index_date) VALUES (?, ?, ?);'

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
        document_time = Time.now + 1.second
        insert_command.execute('1234', 'doc type 1', document_time)

        event = DocumentAssignedEvents.fetch_all_new.first
        expect(event.caseid).to eql '1234'
        expect(event.type).to eql 'doc type 1'
        expect(event.date.strftime('%a %b %e %T %Y')).to eql document_time.strftime('%a %b %e %T %Y')
      end
    end

    context 'there is are multiple event' do
      it 'fetches all events' do
        current_time = Time.now
        EventCursor.document_assigned_events_cursor = current_time

        insert_command = @client.prepare(INSERT_STATEMENT)
        insert_command.execute('1234', 'doc type 1', current_time + 1.second)
        insert_command.execute('1235', 'doc type 1', current_time + 2.second)

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 2
      end
    end

    context 'there is are events that did not happen in the last hour' do
      it 'fetches only the events that happened after cursor date' do
        EventCursor.document_assigned_events_cursor = Time.now

        insert_command = @client.prepare(INSERT_STATEMENT)
        insert_command.execute('1235', 'doc type 1',  Time.now - 1.second)
        insert_command.execute('1234', 'doc type 1',  Time.now + 1.second)

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 1
      end

      it 'does not fetch events again' do
        EventCursor.document_assigned_events_cursor = Time.now - 1.hour

        insert_command = @client.prepare(INSERT_STATEMENT)
        insert_command.execute('1235', 'doc type 1',  Time.now - 10.minutes)
        insert_command.execute('3456', 'doc type 1',  Time.now - 30.minutes)
        insert_command.execute('2345', 'doc type 2',  Time.now - 20.minutes)

        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 3
        expect(DocumentAssignedEvents.fetch_all_new.length).to eql 0
      end
    end
  end
end
