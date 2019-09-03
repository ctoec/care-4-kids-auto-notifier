# frozen_string_literal: true

DocumentAssignedEvent = Struct.new(:caseid, :type, :source, :date)

class DocumentAssignedEvents
    @@client = TinyTds::Client.new(
      username: ENV.fetch('UNITEDWAYDB_USERNAME'),
      password: ENV.fetch('UNITEDWAYDB_PASSWORD'),
      host: ENV.fetch('UNITEDWAYDB_HOST'),
      port: 1433,
      database: 'Docuclass_Reporting',
      azure: false
    )
  def self.fetch_all_new
    events_cursor = EventCursor.document_assigned_events_cursor
    query = <<-SQL
      DECLARE @LastFetchedDateTime smalldatetime = \"#{events_cursor.strftime('%Y-%m-%d %H:%M:00')}\"

      select Doc.c2 as ClientID,
            case when ltrim(rtrim(isnull(Doc.c1022,''))) = '' then 'Unknown' else Doc.c1022 end as DocType,
            Doc.ArchivedAt, 
            Doc.c17 as CallerID, 
            --WFSP.DateEntered as ExportDate,
            --WFSP.TimeEntered as ExportTime,
            Typ.TypeName as Source,
            Doc.IDDocuments as DocID
      from documents as Doc 
      left outer join Types as Typ on Doc.TypeId = Typ.IDTypes 
      left outer join workflowinstances as WFI on Doc.IDDocuments = WFI.docid 
      left outer join workflowsteps as WFSP on WFI.instanceID = WFSP.instancesID and WFSP.QueueEneredID in (2, 15, 17) 
      where doc.ArchivedAt > @LastFetchedDateTime
      and Doc.TypeId <> 4 --NOT DELETED
      and Doc.Deleted is null --NOT DELETED
      and WFSP.QueueEneredID in (2, 15, 17) --EXPORTED (2)FAXES, (15)EMAILS, (17)SCANS
      --and ltrim(Rtrim(isnull(Doc.c1022,'Unknown'))) in ('RP - Redetermination','SP - Parent Supporting Document','PS - Provider Supporting Document') --DOCUMENT TYPE
    SQL
    events = @@client
      .execute(query)
      .map { |row| build_event row }
      .compact
    update_cursor(events: events)
  end

  def self.update_cursor(events:)
    unless events.empty?
      most_recent_event_time = events.pluck(:date).sort.last
      EventCursor.document_assigned_events_cursor = most_recent_event_time
    end
    events
  end

  def self.build_event(row)
    begin
      DocumentAssignedEvent.new(
        parse_client_id_from_export(row),
        parse_doc_type_from_export(row),
        parse_source_from_export(row),
        parse_datetime_from_export(row)
      )
    rescue InvalidDocuclassDataTypeError => e
      Rails.logger.error e
      nil
    end
  end

  def self.parse_client_id_from_export(row)
    row['ClientID']
  end

  def self.parse_doc_type_from_export(row)
    doc_type = row['DocType']
    # Handling both '-' and '–' due to character encoding mismatch
    if (
      ![
        'RP - Redetermination',
        'SP - Parent Supporting Document',
        'PS - Provider Supporting Document',
        'RP – Redetermination',
        'SP – Parent Supporting Document',
        'PS – Provider Supporting Document',
      ].include?(doc_type)
    ) then
      raise InvalidDocuclassDataTypeError.new("Invalid DocType: #{doc_type}")
    end

    if doc_type.include?('-') then
      doc_type_parts = doc_type.split(' - ')
    else
      doc_type_parts = doc_type.split(' – ')
    end
    doc_type_parts[1].downcase
  end

  def self.parse_source_from_export(row)
    source = row['Source']
    if (!['Fax', 'Emails', 'Scans'].include?(source))
      raise InvalidDocuclassDataTypeError.new("Invalid Source: #{source}")
    end
    case source
    when 'Fax'
      'fax'
    when 'Emails'
      'web upload'
    when 'Scans'
      'mail'
    end
  end

  def self.parse_datetime_from_export(row)
    row['ArchivedAt']
  end
end
