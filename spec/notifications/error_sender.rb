class ErrorSender
  def self.createMessage(*vargs)
    raise Twilio::REST::TwilioError
  end
end