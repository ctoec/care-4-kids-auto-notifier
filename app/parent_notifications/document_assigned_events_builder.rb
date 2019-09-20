DocumentAssignedEvent = Struct.new(:caseid, :type, :source, :date)

class DocumentAssignedEventsBuilder
  def self.parse_row(row)
    DocumentAssignedEvent.new(
      self.parse_client_id(row),
      self.parse_doc_type(row),
      self.parse_source(row),
      self.parse_datetime(row)
    )
  end

  def self.parse_client_id(row)
    raise InvalidDocuclassDataTypeError.new("Missing Key: ClientID") unless row.key?('ClientID')

    row['ClientID']
  end

  def self.parse_doc_type(row)
    raise InvalidDocuclassDataTypeError.new("Missing Key: DocType") unless row.key?('DocType')

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

  def self.parse_source(row)
    raise InvalidDocuclassDataTypeError.new("Missing Key: Source") unless row.key?('Source')

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

  def self.parse_datetime(row)
    raise InvalidDocuclassDataTypeError.new("Missing Key: ArchivedAt") unless row.key?('ArchivedAt')

    row['ArchivedAt']
  end
end
