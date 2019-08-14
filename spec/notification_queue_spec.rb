require 'rails_helper'

RSpec.describe NotificationQueue do
  describe 'when constructor is supplied objects of type ApplicationJob and Scheduler' do
    it do
      sender = double
      scheduler = double
      allow(sender).to receive(:included_modules).and_return([ApplicationJob])
      allow(scheduler).to receive(:included_modules).and_return([Scheduler])
      expect {
        NotificationQueue.new(sender, scheduler)
      }.to_not raise_error
    end
  end

  describe 'when constructor is supplied objects not of type ApplicationJob and Scheduler' do
    it do
      sender = double
      scheduler = double
      allow(sender).to receive(:included_modules).and_return([])
      allow(scheduler).to receive(:included_modules).and_return([])
      expect {
        NotificationQueue.new(sender, scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when constructor is supplied objects of type ApplicationJob and not of Scheduler' do
    it do
      sender = double
      scheduler = double
      allow(sender).to receive(:included_modules).and_return([ApplicationJob])
      allow(scheduler).to receive(:included_modules).and_return([])
      expect {
        NotificationQueue.new(sender, scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when constructor is supplied objects of type Scheduler and not of ApplicationJob' do
    it do
      sender = double
      scheduler = double
      allow(sender).to receive(:included_modules).and_return([])
      allow(scheduler).to receive(:included_modules).and_return([Scheduler])
      expect {
        NotificationQueue.new(sender, scheduler)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when no notifications are given' do
    it '#perform_(later|now) is called zero times' do
      scheduler = spy
      sender = spy
      allow(sender).to receive(:perform_now)
      allow(sender).to receive(:perform_later)

      notificiationQueue = NotificationQueue.new(sender, scheduler)
      
      expect(sender).to have_received(:perform_now).exactly(0).times
      expect(sender).to have_received(:perform_later).exactly(0).times
    end
  end

  describe 'when one notification is given' do
    it '#perform_(later|now) is called at most one time' do
      scheduler = spy
      sender = spy
      allow(sender).to receive(:perform_now)
      allow(sender).to receive(:perform_later)
      notification = spy

      notificiationQueue = NotificationQueue.new(sender, scheduler)
      notificiationQueue.put notification

      expect(sender).to have_received(:perform_now).at_most(:once)
      expect(sender).to have_received(:perform_later).at_most(:once)
    end
  end

  describe 'when several notifications are given' do
    it '#perform_(later|now) is called no more than the same number of times' do
      scheduler = spy
      sender = spy
      allow(sender).to receive(:perform_now)
      allow(sender).to receive(:perform_later)
      notification = spy
      quantity = rand(1..20)

      notificiationQueue = NotificationQueue.new(sender, scheduler)
      quantity.times do
        notificiationQueue.put notification
      end

      expect(sender).to have_received(:perform_now).at_most(quantity).times
      expect(sender).to have_received(:perform_later).at_most(quantity).times
    end
  end
end