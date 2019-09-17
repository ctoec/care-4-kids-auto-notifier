# frozen_string_literal: true

class Parent < ApplicationRecord
  @@CELLPHONENUMBER_ENCRYPTION_KEY = Base64.decode64 ENV.fetch 'CELLPHONENUMBER_ENCRYPTION_KEY'

  attr_encrypted_options.merge!(marshal: true, allow_empty_value: true)

  attr_encrypted :cellphonenumber, key: @@CELLPHONENUMBER_ENCRYPTION_KEY

  def increment_notifications_count!
    self.increment!(:notifications_generated_count)
  end

  def send_follow_up?
    self.notifications_generated_count == 1
  end
end
