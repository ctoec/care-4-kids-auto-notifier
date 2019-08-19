require 'rails_helper'

INSERT_STATEMENT = "INSERT INTO docuclass_indexed(caseid, document_type, index_date) VALUES (?, ?, ?);"

RSpec.describe DocumentAssignedEvents do
  before(:all) do
    @client = Mysql2::Client.new(
      :host => "unitedwaydb",
      :username => "root",
      :password => "password",
      :database => "unitedwayetl"
    )
  end

  before(:each) do
    @client.prepare("DELETE FROM docuclass_indexed;").execute;
  end

  describe 'fetch_last_hour' do
    context 'there are no events' do
      it 'returns nothing' do
        insert_command = @client.prepare(INSERT_STATEMENT)
        current_time = Time.now
        expect(DocumentAssignedEvents.fetch_last_hour.length).to eql 0
      end
    end

    context 'there is one event' do
      it 'fetches one event with the correct format' do
        insert_command = @client.prepare(INSERT_STATEMENT)
        current_time = Time.now
        insert_command.execute('1234', 'doc type 1', current_time)

        event = DocumentAssignedEvents.fetch_last_hour.first
        expect(event.caseid).to eql '1234'
        expect(event.type).to eql 'doc type 1'
        expect(event.date.strftime("%a %b %e %T %Y")).to eql current_time.strftime("%a %b %e %T %Y")
      end
    end

    context 'there is are multiple event' do
      it 'fetches all events' do
        insert_command = @client.prepare(INSERT_STATEMENT)
        current_time = Time.now
        insert_command.execute('1234', 'doc type 1', current_time)
        insert_command.execute('1235', 'doc type 1', current_time)
        expect(DocumentAssignedEvents.fetch_last_hour.length).to eql 2
      end
    end

    context 'there is are events that did not happen in the last hour' do
      it 'fetches only the events that have a timestamp of last hour' do
        insert_command = @client.prepare(INSERT_STATEMENT)
        current_time = Time.now
        insert_command.execute('1234', 'doc type 1', current_time)
        insert_command.execute('1235', 'doc type 1', Time.new(2010, 1, 1))
        expect(DocumentAssignedEvents.fetch_last_hour.length).to eql 1
      end
    end
  end
end
