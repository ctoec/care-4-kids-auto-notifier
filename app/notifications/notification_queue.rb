class NotificationQueue
  def initialize(sender, scheduler)
    if (sender.included_modules.include?(ApplicationJob)) then
      @sender = sender
    else
      raise ArgumentError.new('sender should be of type ApplicationJob')
    end
    if (scheduler.included_modules.include?(Scheduler)) then
      @scheduler = scheduler
    else
      raise ArgumentError.new('scheduler should be of type ApplicationJob')
    end
  end

  def put(notification_event)
    send_time = @scheduler.getNextSendTime
    if (send_time + 1.second < Time.now) then
      @sender.perform_now notification_event
    else
      @sender.perform_later notification_event
    end
  end
end