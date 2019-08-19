class ImmediateScheduler
  include Scheduler

  def self.schedule(job, *objs)
    job.perform_now(objs)
  end
end