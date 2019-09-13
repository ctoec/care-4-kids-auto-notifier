class ErrorSender
  def self.createMessage(*vargs)
    raise StandardError
  end
end