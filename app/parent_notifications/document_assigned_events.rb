DocumentAssignedEvent = Struct.new(:caseid, :type, :date)

class DocumentAssignedEvents
    @@client = Mysql2::Client.new(
        host: ENV.fetch('UNITEDWAYDB_HOST'),
        username: ENV.fetch('UNITEDWAYDB_USERNAME'),
        password: ENV.fetch('UNITEDWAYDB_PASSWORD'),
        database: ENV.fetch('UNITEDWAYDB_DATABASE')
    )

    def self.fetch_last_hour
        query = <<-SQL
            SELECT * 
            FROM docuclass_indexed 
            WHERE index_date >= DATE_SUB(NOW(),INTERVAL 1 HOUR);
        SQL
        @@client.prepare(query).execute.map do |row|
            DocumentAssignedEvent.new(
                row["caseid"], 
                row["document_type"], 
                row["index_date"]
            )
        end
    end
end