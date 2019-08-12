require 'rails_helper'

RSpec.describe NotificationManager do
  it 'enqueues a message' do
    message_queue = spy
    message_generator = double
    allow(message_generator).to receive(:each)
      .and_yield('message 1')
    notification_manager = NotificationManager.new message_queue: message_queue, message_generator: message_generator
    notification_manager.run
    expect(message_queue).to have_received(:put).with('message 1')
  end

  it 'enqueues multiple messages' do
    message_queue = spy
    message_generator = double
    allow(message_generator).to receive(:each)
      .and_yield('message 1')
      .and_yield('message 2')
      .and_yield('message 3')
  
    notification_manager = NotificationManager.new message_queue: message_queue, message_generator: message_generator
    notification_manager.run
    expect(message_queue).to have_received(:put).exactly(3).times
  end
end
