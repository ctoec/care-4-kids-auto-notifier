require 'rails_helper'

RSpec.describe NotificationManager do
  describe 'run' do
    it 'enqueues a message' do
      message_queue = spy
      notification_generator = double
      allow(notification_generator).to receive(:fetch_all_new)
        .and_yield('fake message 1')
      notification_manager = NotificationManager.new message_queue: message_queue, notification_generator: notification_generator
      notification_manager.run
      expect(message_queue).to have_received(:put).with('fake message 1')
    end

    it 'enqueues multiple messages' do
      message_queue = spy
      notification_generator = double
      allow(notification_generator).to receive(:fetch_all_new)
        .and_yield('fake message 1')
        .and_yield('fake message 2')
        .and_yield('fake message 3')

      notification_manager = NotificationManager.new message_queue: message_queue, notification_generator: notification_generator
      notification_manager.run
      expect(message_queue).to have_received(:put).exactly(3).times
    end
  end
end
