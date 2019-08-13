class ImmediateScheduler
  include Scheduler

  def self.getNextTime(*_)
    return Time.now
  end
end