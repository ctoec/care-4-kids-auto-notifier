require 'rails_helper'

RSpec.describe NotificationQueue do
  describe 'when constructor is supplied objects of type ApplicationJob, Sender, and Scheduler' do
    it do
      job = double
      sender = double
      scheduler = double
      allow(job).to receive(:included_modules).and_return([ApplicationJob])
      allow(sender).to receive(:included_modules).and_return([Sender])
      allow(scheduler).to receive(:included_modules).and_return([Scheduler])
      expect {
        NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      }.to_not raise_error
    end
  end

  describe 'when constructor is supplied objects of all invalid types' do
    it do
      job = double
      sender = double
      scheduler = double
      allow(job).to receive(:included_modules).and_return([])
      allow(sender).to receive(:included_modules).and_return([])
      allow(scheduler).to receive(:included_modules).and_return([])
      expect {
        NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when constructor is supplied objects with only ApplicationJob correct' do
    it do
      job = double
      sender = double
      scheduler = double
      allow(job).to receive(:included_modules).and_return([ApplicationJob])
      allow(sender).to receive(:included_modules).and_return([])
      allow(scheduler).to receive(:included_modules).and_return([])
      expect {
        NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when constructor is supplied objects with only Sender correct' do
    it do
      job = double
      sender = double
      scheduler = double
      allow(job).to receive(:included_modules).and_return([])
      allow(sender).to receive(:included_modules).and_return([Sender])
      allow(scheduler).to receive(:included_modules).and_return([])
      expect {
        NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when constructor is supplied objects with only Scheduler correct' do
    it do
      job = double
      sender = double
      scheduler = double
      allow(job).to receive(:included_modules).and_return([])
      allow(sender).to receive(:included_modules).and_return([])
      allow(scheduler).to receive(:included_modules).and_return([Scheduler])
      expect {
        NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when no notifications are given' do
    it '#perform_(later|now) is called zero times' do
      job = spy
      sender = spy
      scheduler = spy
      allow(job).to receive(:perform_now)
      allow(job).to receive(:perform_later)

      notificiationQueue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      
      expect(job).to have_received(:perform_now).exactly(0).times
      expect(job).to have_received(:perform_later).exactly(0).times
    end
  end

  describe 'when one notification is given' do
    it '#perform_(later|now) is called at most one time' do
      job = spy
      sender = spy
      scheduler = spy
      allow(job).to receive(:perform_now)
      allow(job).to receive(:perform_later)
      notification = spy

      notificiationQueue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      notificiationQueue.put notification

      expect(job).to have_received(:perform_now).at_most(:once)
      expect(job).to have_received(:perform_later).at_most(:once)
    end
  end

  describe 'when several notifications are given' do
    it '#perform_(later|now) is called no more than the same number of times' do
      job = spy
      sender = spy
      scheduler = spy
      allow(job).to receive(:perform_now)
      allow(job).to receive(:perform_later)
      notification = spy
      quantity = rand(1..20)

      notificiationQueue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      quantity.times do
        notificiationQueue.put notification
      end

      expect(job).to have_received(:perform_now).at_most(quantity).times
      expect(job).to have_received(:perform_later).at_most(quantity).times
    end
  end
end