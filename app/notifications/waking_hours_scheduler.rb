# frozen_string_literal: true

class WakingHoursScheduler
  @@EarliestTime = 8
  @@LatestTime = 21

  def self.schedule(job, *objs)
    if isTooEarly || isTooLate then
      job.set(wait_until: getNextScheduleTime).perform_later(*objs)
    else
      job.perform_now(*objs)
    end
  end

  def self.getNextScheduleTime
    now = Time.now
    if isTooEarly then
      Time.new(now.year, now.month, now.day, @@EarliestTime, 0, 0)
    elsif isTooLate
      Time.new(now.year, now.month, now.day + 1, @@EarliestTime, 0, 0)
    else
      now
    end
  end

  def self.isTooEarly
    Time.now.hour < @@EarliestTime
  end

  def self.isTooLate
    Time.now.hour >= @@LatestTime
  end
end
