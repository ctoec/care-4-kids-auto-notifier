require 'rails_helper'

RSpec.describe ImmediateScheduler do
  it '.schedule calls perform_now on a job' do
    job = double
    allow(job).to receive(:perform_now)

    ImmediateScheduler.schedule(job)

    expect(job).to have_received(:perform_now).exactly(:once)
  end
end
