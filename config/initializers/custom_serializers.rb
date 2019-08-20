require 'uninitialized_class_serializer'
require 'notification_event_serializer'

Rails.application.config.active_job.custom_serializers << UninitializedClassSerializer
Rails.application.config.active_job.custom_serializers << NotificationEventSerializer