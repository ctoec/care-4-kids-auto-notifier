
DocuclassEvent = Struct.new(:type, :caseid)
NotificationEvent = Struct.new(:caseid, :notificationid)

class IndexedDocuments
    def initialize(docuclass_events:)
        @docuclass_events = docuclass_events
    end

    def fetch_last_hour
        @docuclass_events.fetch_last_hour.each do |event|
            found_parent = Applicant.where(caseid: event.caseid).first
            yield build_notification_event(event: event) unless found_parent.nil?
        end
    end

    def build_notification_event(event:)
        notification = Notification.create(
            message_text: "We have received document #{event.type}", 
        )
        NotificationEvent.new(event.caseid, notification.id)
    end

end
