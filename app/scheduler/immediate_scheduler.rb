class ImmediateScheduler
  def self.schedule(job, *objs)
    job.perform_now(objs)
  end
end
