class NotificationQueue
  def initialize(job:, sender:, scheduler:)
    if (job.included_modules.include?(ApplicationJob)) then
      @job = job
    else
      raise ArgumentError.new('job should be of type ApplicationJob')
    end
    if (sender.included_modules.include?(Sender)) then
      @sender = sender
    else
      raise ArgumentError.new('sender should be of type Sender')
    end
    if (scheduler.included_modules.include?(Scheduler)) then
      @scheduler = scheduler
    else
      raise ArgumentError.new('scheduler should be of type Scheduler')
    end
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