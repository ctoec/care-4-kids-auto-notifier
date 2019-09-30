RSpec.describe DocumentAssignedEventsBuilder do
  it 'extracts the client id' do
    random_number = rand.i
    row = {
      'ClientID' => random_number,
      'DocType' => 'RP - Redetermination',
      'Source' => 'Fax',
      'ExportDate' => Time.now.strftime('%Y-%m-%d')
    }
    document_assigned_event = DocumentAssignedEventsBuilder.parse_row(row)
    expect(document_assigned_event.caseid).to equal random_number
  end

  it 'extracts the archived at date' do
    date = Time.now.strftime('%Y-%m-%d')
    row = {
      'ClientID' => 1,
      'DocType' => 'RP - Redetermination',
      'Source' => 'Fax',
      'ExportDate' => date
    }
    document_assigned_event = DocumentAssignedEventsBuilder.parse_row(row)
    expect(document_assigned_event.date).to equal date
  end

  it 'raises error if all keys do not exist' do
    date = Time.now.strftime('%Y-%m-%d')
    [
      {
        'DocType' => 'RP - Redetermination',
        'Source' => 'Fax',
        'ExportDate' => date
      },
      {
        'ClientID' => 1,
        'Source' => 'Fax',
        'ExportDate' => date
      },
      {
        'ClientID' => 1,
        'DocType' => 'RP - Redetermination',
        'ExportDate' => date
      },
      {
        'ClientID' => 1,
        'DocType' => 'RP - Redetermination',
        'Source' => 'Fax',
      }
    ].each do |broken_row|
      expect { DocumentAssignedEventsBuilder.parse_row(broken_row) }.to raise_error InvalidDocuclassDataTypeError
    end
  end

  context 'doc types' do
    it 'extracts and transforms all doc types' do
      parsed_documents = [
        'RP - Redetermination',
        'SP - Parent Supporting Document',
        'PS - Provider Supporting Document',
        'RP – Redetermination',
        'SP – Parent Supporting Document',
        'PS – Provider Supporting Document',
      ].map do |doc_type|
        DocumentAssignedEventsBuilder.parse_row(
          { 'ClientID' => 1,
            'DocType' => doc_type,
            'Source' => 'Fax',
            'ExportDate' => Time.now.strftime('%Y-%m-%d') }
        )
      end
      expect(parsed_documents.map(&:type)).to eq [
        'redetermination',
        'parent supporting document',
        'provider supporting document',
        'redetermination',
        'parent supporting document',
        'provider supporting document',
      ]
    end
    it 'raises errors on invalid doc types' do
      random_number = rand.i
      row = {
        'ClientID' => random_number,
        'DocType' => 'Invalid',
        'Source' => 'Fax',
        'ExportDate' => Time.now.strftime('%Y-%m-%d')
      }
      expect { DocumentAssignedEventsBuilder.parse_row(row) }.to raise_error InvalidDocuclassDataTypeError
    end
  end

  context 'doc sources' do
    it 'extracts and transforms all doc sources' do
      parsed_documents = ['Fax', 'Emails', 'Scans'].map do |source|
        DocumentAssignedEventsBuilder.parse_row(
          { 'ClientID' => 1, 'DocType' => 'RP - Redetermination', 'Source' => source, 'ExportDate' => Time.now.strftime('%Y-%m-%d') }
        )
      end
      expect(parsed_documents.map(&:source)).to eq ['fax', 'web upload', 'mail']
    end

    it 'raises errors on invalid sources' do
      random_number = rand.i
      row = {
        'ClientID' => random_number,
        'DocType' => 'RP - Redetermination',
        'Source' => 'Invalid',
        'ExportDate' => Time.now.strftime('%Y-%m-%d')
      }
      expect { DocumentAssignedEventsBuilder.parse_row(row) }.to raise_error InvalidDocuclassDataTypeError
    end
  end
end
