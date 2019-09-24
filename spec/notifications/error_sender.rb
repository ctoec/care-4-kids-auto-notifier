class ErrorSender
  def self.createMessage(*vargs)
    raise Twilio::REST::RestError.new('Fake error message', Twilio::Response.new(500, ''))
  end
end