# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationQueue do
  context 'when no notifications are given' do
    it '.schedulle is called zero times' do
      job = spy
      sender = spy
      scheduler = spy
      allow(scheduler).to receive(:schedule)

      notificiation_queue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)

      expect(scheduler).to have_received(:schedule).exactly(0).times
    end
  end

  context 'when one notification is given' do
    it '.schedule is called at exactly one time' do
      job = spy
      sender = spy
      scheduler = spy
      allow(scheduler).to receive(:schedule)
      notification = spy

      notificiation_queue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      notificiation_queue.put notification

      expect(scheduler).to have_received(:schedule).exactly(:once)
    end
  end

  context 'when several notifications are given' do
    it '.schedule is called exactly the same number of times' do
      job = spy
      sender = spy
      scheduler = spy
      allow(scheduler).to receive(:schedule)
      notification = spy
      quantity = rand(1..20)

      notificiation_queue = NotificationQueue.new(job: job, sender: sender, scheduler: scheduler)
      quantity.times do
        notificiation_queue.put notification
      end

      expect(scheduler).to have_received(:schedule).exactly(quantity).times
    end
  end
end
