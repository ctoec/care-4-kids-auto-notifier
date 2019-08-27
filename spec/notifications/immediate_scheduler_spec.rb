require 'rails_helper'

RSpec.describe ImmediateScheduler do
  it '.schedule calls perform_now on a job' do
    job = double
    allow(job).to receive(:perform_now)

    ImmediateScheduler.schedule(job)

    expect(job).to have_received(:perform_now).exactly(:once)
  end

  context 'when one parameter is supplied to scheduler' do
    it '.schedule calls perform_now on a job with supplied parameter' do
      job = double
      allow(job).to receive(:perform_now)

      ImmediateScheduler.schedule(job, 'parameter')

      expect(job).to have_received(:perform_now).exactly(:once)
      expect(job).to have_received(:perform_now).with('parameter')
    end
  end

  context 'when many parameter are supplied to scheduler' do
    it '.schedule calls perform_now on a job with supplied parameter' do
      job = double
      allow(job).to receive(:perform_now)

      ImmediateScheduler.schedule(job, 'parameter 1', 2, nil)

      expect(job).to have_received(:perform_now).exactly(:once)
      expect(job).to have_received(:perform_now).with('parameter 1', 2, nil)
    end
  end
end
