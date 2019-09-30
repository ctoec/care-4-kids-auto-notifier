# frozen_string_literal: true

require 'rails_helper'
require 'sqlserver_helper'

RSpec.describe DocumentAssignedEventsRepository do
  before(:all) do
    @write_client = SQLServerClient.new
    @write_client.setup_types_table
  end

  before(:each) do
    EventCursor.create(key: 'document_assigned_event', time: Time.now)
    @write_client.clean_database
  end

  describe 'fetch_all_new' do
    context 'there are no events' do
      it 'returns nothing' do
        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 0
      end
    end

    context 'there is one new event' do
      it 'fetches one event with the correct format' do
        EventCursor.document_assigned_events_cursor = Time.now

        document_datetime = Time.now + 1.days
        document_date = document_datetime.to_date
        document_time = document_datetime.strftime("%H:%M:%S")
        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::FAX,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        event = DocumentAssignedEventsRepository.fetch_all_new.first
        expect(event.caseid).to eql '1'
        expect(event.type).to eql 'redetermination'
        expect(event.source).to eql 'fax'
        expect(event.date.to_date).to eql document_date
      end

      it 'does not fetch events that have a deleted type' do
        EventCursor.document_assigned_events_cursor = Time.now

        document_datetime = Time.now + 1.minutes
        document_date = document_datetime.to_date
        document_time = document_datetime.strftime("%H:%M:%S")
        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::DELETED,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 0
      end

      it 'does not fetch events that are marked as deleted in documents table' do
        EventCursor.document_assigned_events_cursor = Time.now

        document_datetime = Time.now + 1.minutes
        document_date = document_datetime.to_date
        document_time = document_datetime.strftime("%H:%M:%S")
        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::FAX,

          archivedAt: document_datetime,
          deleted: 1,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 0
      end

      it 'does only fetch events that are faxes emails and scans in workflowsteps table' do
        EventCursor.document_assigned_events_cursor = Time.now

        document_datetime = Time.now + 1.days
        document_date = document_datetime.to_date
        document_time = document_datetime.strftime("%H:%M:%S")
        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::FAX,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        result = @write_client.insert(
          doc_id: 2,
          typeId: SQLServerClient::EMAILS,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 2,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        result = @write_client.insert(
          doc_id: 3,
          typeId: SQLServerClient::SCANS,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 3,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        result = @write_client.insert(
          doc_id: 5,
          typeId: SQLServerClient::OTHER,

          archivedAt: document_datetime,
          deleted: nil,
          client_id: '1',
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 5,

          dateEntered: document_date,
          timeEntered: document_time,
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 3
      end
    end

    context 'there is are multiple event' do
      it 'fetches all events' do
        current_datetime = Time.now

        future_datetime = current_datetime + 1.days
        future_date = future_datetime.to_date
        future_time = future_datetime.strftime("%H:%M:%S")

        later_future_datetime = future_datetime + 1.days
        later_future_date = later_future_datetime.to_date
        later_future_time = later_future_datetime.strftime("%H:%M:%S")

        EventCursor.document_assigned_events_cursor = current_datetime

        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::FAX,

          archivedAt: future_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: future_date,
          timeEntered: future_time,
        )

        result = @write_client.insert(
          doc_id: 2,
          typeId: SQLServerClient::FAX,

          archivedAt: later_future_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 2,

          dateEntered: later_future_date,
          timeEntered: later_future_time,
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 2
      end
    end

    context 'there are events that did not happen in the last hour' do
      it 'fetches only the events that happened after cursor date' do
        current_datetime = Time.now

        future_datetime = current_datetime + 1.days
        future_date = future_datetime.to_date
        future_time = future_datetime.strftime("%H:%M:%S")

        earlier_datetime = current_datetime - 1.days
        earlier_date = earlier_datetime.to_date
        earlier_time = earlier_datetime.strftime("%H:%M:%S")

        EventCursor.document_assigned_events_cursor = current_datetime

        result = @write_client.insert(
          doc_id: 1,
          typeId: SQLServerClient::EMAILS,

          archivedAt: future_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 1,

          dateEntered: future_date,
          timeEntered: future_time,
        )

        result = @write_client.insert(
          doc_id: 2,
          typeId: SQLServerClient::FAX,

          archivedAt: earlier_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 2,

          dateEntered: earlier_date,
          timeEntered: earlier_time,
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 1
      end

      it 'does not fetch events again' do
        EventCursor.document_assigned_events_cursor = Time.now - 1.days

        current_datetime = Time.now
        old_datetime = current_datetime - 10.minutes
        older_datetime = current_datetime - 20.minutes
        oldest_datetime = current_datetime - 30.minutes

        result = @write_client.insert(
          doc_id: 11,
          typeId: SQLServerClient::EMAILS,

          archivedAt: old_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 4,

          dateEntered: old_datetime.to_date,
          timeEntered: old_datetime.strftime('%H:%M:%S')
        )

        result = @write_client.insert(
          doc_id: 5,
          typeId: SQLServerClient::SCANS,

          archivedAt: older_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 5,

          dateEntered: older_datetime.to_date,
          timeEntered: older_datetime.strftime("%H:%M:%S")
        )

        result = @write_client.insert(
          doc_id: 6,
          typeId: SQLServerClient::FAX,

          archivedAt: oldest_datetime,
          deleted: nil,
          client_id: 123,
          c17: '5551239876',
          doc_type: 'RP - Redetermination',

          instanceId: 2,

          dateEntered: oldest_datetime.to_date,
          timeEntered: oldest_datetime.strftime("%H:%M:%S")
        )

        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 3
        expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 0
      end
    end
  end

  context 'when an event has an invalid data' do
    it 'does not return the event' do
      EventCursor.document_assigned_events_cursor = Time.now

      document_datetime = Time.now + 1.minutes
      document_date = document_datetime.to_date
      document_time = document_datetime.strftime("%H:%M:%S")
      result = @write_client.insert(
        doc_id: 1,
        typeId: SQLServerClient::FAX,

        archivedAt: document_datetime,
        deleted: nil,
        client_id: '1',
        c17: '5551239876',
        doc_type: 'not a valid document type',

        instanceId: 1,

        dateEntered: document_date,
        timeEntered: document_time
      )

      expect(DocumentAssignedEventsRepository.fetch_all_new.length).to eql 0
    end
  end

end
