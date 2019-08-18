class NotificationQueue
  def initialize(job:, sender:, scheduler:)
      @job = job
      @sender = sender
      @scheduler = scheduler
  end

  def put(notification_event)
    send_time = @scheduler.getNextTime
    if (send_time < Time.now + 1.second) then
      @job.perform_now(@sender, notification_event)
    else
      @job.set(wait_until: send_time).perform_later(@sender, notification_event)
    end
  end
end