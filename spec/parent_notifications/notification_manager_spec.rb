require 'rails_helper'

RSpec.describe NotificationManager do
  describe 'run' do
      it 'enqueues a message' do
        message_queue = spy
        indexed_documents = double
        allow(indexed_documents).to receive(:fetch_last_hour)
          .and_yield('fake message 1')
        notification_manager = NotificationManager.new message_queue: message_queue, indexed_documents: indexed_documents
        notification_manager.run
        expect(message_queue).to have_received(:put).with('fake message 1')
      end
    
      it 'enqueues multiple messages' do
        message_queue = spy
        indexed_documents = double
        allow(indexed_documents).to receive(:fetch_last_hour)
          .and_yield('fake message 1')
          .and_yield('fake message 2')
          .and_yield('fake message 3')
      
        notification_manager = NotificationManager.new message_queue: message_queue, indexed_documents: indexed_documents
        notification_manager.run
        expect(message_queue).to have_received(:put).exactly(3).times
    end
  end
end
