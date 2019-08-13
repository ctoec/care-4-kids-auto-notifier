
DocuclassEvent = Struct.new(:type, :caseid)
Message = Struct.new(:text, :cellphonenumber)

class IndexedDocuments
    def initialize(docuclass_events:)
        @docuclass_events = docuclass_events
    end

    def fetch_last_hour
        @docuclass_events.fetch_last_hour.each do |event|
            found_parent = Applicant.where(caseid: event.caseid).first
            yield Message.new(
                "We have received document #{event.type}", 
                found_parent.cellphonenumber
            ) unless found_parent.nil?
        end
    end
end
