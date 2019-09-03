require 'rails_helper'

RSpec.describe WakingHoursScheduler do
  context 'when it is before 8am' do
    it '.schedule calls set perform_later with 8am' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am - 1.hour)

      WakingHoursScheduler.schedule(job)

      expect(job).to have_received(:set).with(wait_until: eight_am)
      expect(job).to have_received(:perform_later).exactly(:once)

      Timecop.return
    end
  end

  context 'when it is 8am' do
    it '.schedule calls set perform_now' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_now)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am)

      WakingHoursScheduler.schedule(job)

      expect(job).to have_received(:perform_now).exactly(:once)

      Timecop.return
    end
  end

  context 'when it is after 8am but before 9pm' do
    it '.schedule calls set perform_now' do
      job = double
      allow(job).to receive(:perform_now)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am + 1.hour)

      WakingHoursScheduler.schedule(job)

      expect(job).to have_received(:perform_now).exactly(:once)

      Timecop.return
    end
  end

  context 'when it is 9am' do
    it '.schedule calls set perform_later with 8am the next day' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      nine_pm = Time.new(2010, 1, 1, 21, 0, 0)
      eight_am_the_next_day = Time.new(2010, 1, 2, 8, 0, 0)
      Timecop.freeze(nine_pm)

      WakingHoursScheduler.schedule(job)

      expect(job).to have_received(:set).with(wait_until: eight_am_the_next_day)
      expect(job).to have_received(:perform_later).exactly(:once)

      Timecop.return
    end
  end

  context 'when it is after 9pm' do
    it '.schedule calls set perform_later with 8am the next day' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      nine_pm = Time.new(2010, 1, 1, 21, 0, 0)
      eight_am_the_next_day = Time.new(2010, 1, 2, 8, 0, 0)
      Timecop.freeze(nine_pm + 1.hour)

      WakingHoursScheduler.schedule(job)

      expect(job).to have_received(:set).with(wait_until: eight_am_the_next_day)
      expect(job).to have_received(:perform_later).exactly(:once)

      Timecop.return
    end
  end

  context 'when it is before 8am and a parameter is supplied' do
    it '.schedule calls set perform_later with 8am with the supplied parameter' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am - 1.hour)

      WakingHoursScheduler.schedule(job, 'test')

      expect(job).to have_received(:set).with(wait_until: eight_am)
      expect(job).to have_received(:perform_later).exactly(:once)
      expect(job).to have_received(:perform_later).with('test')

      Timecop.return
    end
  end

  context 'when it is after 8am but before 9pm and a parameter is supplied' do
    it '.schedule calls set perform_now with the supplied parameter' do
      job = double
      allow(job).to receive(:perform_now)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am + 1.hour)

      WakingHoursScheduler.schedule(job, 'test')

      expect(job).to have_received(:perform_now).exactly(:once)
      expect(job).to have_received(:perform_now).with('test')

      Timecop.return
    end
  end

  context 'when it is after 9pm and a parameter is supplied' do
    it '.schedule calls set perform_later with 8am the next day and the supplied parameter' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      nine_pm = Time.new(2010, 1, 1, 21, 0, 0)
      eight_am_the_next_day = Time.new(2010, 1, 2, 8, 0, 0)
      Timecop.freeze(nine_pm + 1.hour)

      WakingHoursScheduler.schedule(job, 'test')

      expect(job).to have_received(:set).with(wait_until: eight_am_the_next_day)
      expect(job).to have_received(:perform_later).exactly(:once)
      expect(job).to have_received(:perform_later).with('test')

      Timecop.return
    end
  end

  context 'when it is before 8am and many parameters are supplied' do
    it '.schedule calls set perform_later with 8am with the supplied parameters' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am - 1.hour)

      WakingHoursScheduler.schedule(job, 'test', 1, nil)

      expect(job).to have_received(:set).with(wait_until: eight_am)
      expect(job).to have_received(:perform_later).exactly(:once)
      expect(job).to have_received(:perform_later).with('test', 1, nil)

      Timecop.return
    end
  end

  context 'when it is after 8am but before 9pm and many parameters are supplied' do
    it '.schedule calls set perform_now with the supplied parameters' do
      job = double
      allow(job).to receive(:perform_now)
      eight_am = Time.new(2010, 1, 1, 8, 0, 0)
      Timecop.freeze(eight_am + 1.hour)

      WakingHoursScheduler.schedule(job, 'test', 1, nil)

      expect(job).to have_received(:perform_now).exactly(:once)
      expect(job).to have_received(:perform_now).with('test', 1, nil)

      Timecop.return
    end
  end

  context 'when it is after 9pm and many parameters are supplied' do
    it '.schedule calls set perform_later with 8am the next day and the supplied parameters' do
      job = double
      allow(job).to receive(:set).and_return(job)
      allow(job).to receive(:perform_later)
      nine_pm = Time.new(2010, 1, 1, 21, 0, 0)
      eight_am_the_next_day = Time.new(2010, 1, 2, 8, 0, 0)
      Timecop.freeze(nine_pm + 1.hour)

      WakingHoursScheduler.schedule(job, 'test', 1, nil)

      expect(job).to have_received(:set).with(wait_until: eight_am_the_next_day)
      expect(job).to have_received(:perform_later).exactly(:once)
      expect(job).to have_received(:perform_later).with('test', 1, nil)

      Timecop.return
    end
  end
end
