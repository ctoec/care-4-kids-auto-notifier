# frozen_string_literal: true

class WakingHoursScheduler
  @@EarliestTime = 8
  @@LatestTime = 21

  def self.schedule(job, *objs)
    if isTooEarly || isTooLate then
      job.set(wait_until: getScheduleTimeForLater).perform_later(*objs)
    else
      job.perform_now(*objs)
    end
  end

  def self.getScheduleTimeForLater
    now = Time.now
    if isTooEarly then
      next_time = Time.new(now.year, now.month, now.day, @@EarliestTime, 0, 0)
    end
    if isTooLate
      next_time = Time.new(now.year, now.month, now.day + 1, @@EarliestTime, 0, 0)
    end
    next_time
  end

  def self.isTooEarly
    Time.now.hour < @@EarliestTime
  end

  def self.isTooLate
    Time.now.hour >= @@LatestTime
  end
end
