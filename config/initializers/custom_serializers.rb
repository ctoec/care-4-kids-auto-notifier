require 'uninitialized_class_serializer'
require 'notification_event_serializer'

# This appends our custom serializers to the list of serializers that Active Job
# uses when de/serializing arguments to jobs that need to be stored in ActiveRecord.
# See https://github.com/rails/rails/pull/30941 for more details.
Rails.application.config.active_job.custom_serializers << UninitializedClassSerializer
Rails.application.config.active_job.custom_serializers << NotificationEventSerializer