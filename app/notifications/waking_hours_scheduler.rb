# frozen_string_literal: true

class WakingHoursScheduler
  def self.schedule(job, *objs)
    job.perform_now(*objs)
  end

  def self.getNextScheduleTime

  end

  def self.isTooEarly

  end

  def self.isTooLate

  end
end
