class NotificationRunner
    def self.schedule_notifications(sender:)
        message_queue = NotificationQueue.new(
            job: NotificationSendJob, 
            sender: sender, 
            scheduler: ImmediateScheduler
        )
        notification_generator = NotificationGenerator.new(
            document_assigned_events: DocumentAssignedEvents
        )
        notification_manager = NotificationManager.new(
            message_queue: message_queue, notification_generator: notification_generator
        )
        notification_manager.run
    end 
end