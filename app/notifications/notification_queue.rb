# frozen_string_literal: true

class NotificationQueue
  def initialize(job:, sender:, scheduler:)
    @job = job
    @sender = sender
    @scheduler = scheduler
  end

  def put(notification_event)
    @scheduler.schedule(@job, @sender, notification_event)
  end
end
