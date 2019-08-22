# It is not entirely clear why this serializer is necessary.
# See https://github.com/ctoec/care-4-kids-auto-notifier/issues/19
class NotificationEventSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(arg)
    arg.is_a? NotificationEvent
  end

  def serialize(notification_event)
    super(
      "caseid" => notification_event.caseid,
      "notificationid" => notification_event.notificationid
    )
  end

  def deserialize(hash)
    NotificationEvent.new(hash["caseid"], hash["notificationid"])
  end
end