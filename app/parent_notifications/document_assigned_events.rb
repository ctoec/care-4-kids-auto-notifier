DocumentAssignedEvent = Struct.new(:caseid, :type, :date)

class DocumentAssignedEvents
  @@client = Mysql2::Client.new(
    host: ENV.fetch('UNITEDWAYDB_HOST'),
    username: ENV.fetch('UNITEDWAYDB_USERNAME'),
    password: ENV.fetch('UNITEDWAYDB_PASSWORD'),
    database: ENV.fetch('UNITEDWAYDB_DATABASE')
  )

  def self.fetch_new
    query = <<-SQL
            SELECT *
            FROM docuclass_indexed
            WHERE index_date >= ?;
    SQL
    @@client
      .prepare(query)
      .execute(EventCursor.fetch_last_document_assigned_events)
      .map {|row| build_event row}
  end

  def self.build_event(row)
    DocumentAssignedEvent.new(
      row["caseid"],
      row["document_type"],
      row["index_date"]
    )
  end
end
