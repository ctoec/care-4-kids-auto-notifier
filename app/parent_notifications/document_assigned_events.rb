# frozen_string_literal: true

DocumentAssignedEvent = Struct.new(:caseid, :type, :date)

class DocumentAssignedEvents
  @@client = Mysql2::Client.new(
    host: ENV.fetch('UNITEDWAYDB_HOST'),
    username: ENV.fetch('UNITEDWAYDB_USERNAME'),
    password: ENV.fetch('UNITEDWAYDB_PASSWORD'),
    database: ENV.fetch('UNITEDWAYDB_DATABASE')
  )

  def self.fetch_all_new
    query = <<-SQL
            SELECT *
            FROM document_assigned_index
            WHERE index_date >= ?;
    SQL
    @@client
      .prepare(query)
      .execute(EventCursor.document_assigned_events_cursor)
      .map { |row| build_event row }
  end

  def self.build_event(row)
    DocumentAssignedEvent.new(
      row['caseid'],
      row['document_type'],
      row['index_date']
    )
  end
end
