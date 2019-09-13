FAX = 2
EMAILS = 15
SCANS = 17
DELETED = 4
OTHER = 20

def insert_statement(
  doc_id:,
  typeId:,
  archivedAt:,
  deleted:,
  client_id:,
  c17:,
  doc_type:,

  instanceId:,

  dateEntered:,
  timeEntered:,

  sourceAsNumber: # 2, 15, 17 | (Fax, Emails -- Web Uploads, Scans -- Mail)
)
  query = <<-SQL
  INSERT INTO documents (
    idDocuments,
    TypeId,
    ArchivedAt,
    Deleted,
    C2,
    C17,
    C1022
  ) VALUES (
    #{doc_id},
    #{typeId},
    \"#{archivedAt.strftime('%Y-%m-%d %H:%M')}\",
    #{deleted || 'NULL'},
    \"#{client_id}\",
    \"#{c17}\",
    \"#{doc_type}\"
  );

  INSERT INTO workflowinstances (
    instanceID,
    docID
  ) VALUES (
    #{instanceId},
    #{doc_id}
  );

  INSERT INTO workflowsteps (
    instancesID,
    DateEntered,
    TimeEntered,
    QueueEneredID
  ) VALUES (
    #{instanceId},
    \"#{dateEntered}\",
    \"#{timeEntered}\",
    #{sourceAsNumber}
  );
  SQL
end

class SQLServerClient
  def initialize
    @client = TinyTds::Client.new(
      username: ENV.fetch('SA_USERNAME'),
      password: ENV.fetch('SA_PASSWORD'),
      host: ENV.fetch('UNITEDWAYDB_HOST'),
      port: 1433,
      database: 'Docuclass_Reporting',
      azure: false
    )
  end

  def clean_database
    query = <<-SQL
         DELETE FROM documents
         DELETE FROM workflowinstances
         DELETE FROM workflowsteps
    SQL
    @client.execute(query).do
  end

  def setup_types_table
    @client.execute("DELETE FROM types").do
    add_types = <<-SQL
           INSERT INTO types (
             idTypes,
             TypeName
           ) VALUES (
             #{FAX},
             "Fax"
           );
           INSERT INTO types (
             idTypes,
             TypeName
           ) VALUES (
             #{EMAILS},
             "Emails"
           );

           INSERT INTO types (
             idTypes,
             TypeName
           ) VALUES (
             #{SCANS},
             "Scans"
           );

           INSERT INTO types (
             idTypes,
             TypeName
           ) VALUES (
             #{DELETED},
             "Deleted"
           );

           INSERT INTO types (
             idTypes,
             TypeName
           ) VALUES (
             #{OTHER},
             "Other"
           );
    SQL

    @client.execute(add_types).do
  end

  def execute(query)
    @client.execute(query)
  end
end
