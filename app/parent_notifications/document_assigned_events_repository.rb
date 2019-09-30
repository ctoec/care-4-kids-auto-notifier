# frozen_string_literal: true

DocumentAssignedEvent = Struct.new(:caseid, :type, :source, :date)

class DocumentAssignedEventsRepository
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
      DECLARE @LastFetchedDate date = \"#{events_cursor.strftime('%Y-%m-%d')}\"

      select Doc.c2 as ClientID,
            case when ltrim(rtrim(isnull(Doc.c1022,''))) = '' then 'Unknown' else Doc.c1022 end as DocType,
            Doc.ArchivedAt, 
            Doc.c17 as CallerID, 
            WFSP.DateEntered as ExportDate,
            -- WFSP.TimeEntered as ExportTime,
            Typ.TypeName as Source,
            Doc.IDDocuments as DocID
      from documents as Doc 
      left outer join Types as Typ on Doc.TypeId = Typ.IDTypes 
      left outer join workflowinstances as WFI on Doc.IDDocuments = WFI.docid 
      left outer join workflowsteps as WFSP on WFI.instanceID = WFSP.instancesID and WFSP.QueueEneredID in (2, 15, 17) 
      where WFSP.DateEntered > @LastFetchedDate
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
      DocumentAssignedEventsBuilder.parse_row(row)
    rescue InvalidDocuclassDataTypeError => e
      Rails.logger.error e
      nil
    end
  end
end
