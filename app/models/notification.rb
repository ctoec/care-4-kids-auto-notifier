class Notification < ApplicationRecord
  @@MESSAGE_TEXT_ENCRYPTION_KEY = Base64.decode64 ENV.fetch 'MESSAGE_TEXT_ENCRYPTION_KEY'

  attr_encrypted_options.merge!(marshal: true, :allow_empty_value => true)

  attr_encrypted :message_text, key: @@MESSAGE_TEXT_ENCRYPTION_KEY
end
