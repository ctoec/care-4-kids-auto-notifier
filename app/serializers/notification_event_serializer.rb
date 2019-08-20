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