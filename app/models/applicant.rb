class Applicant < ApplicationRecord
  attr_encrypted_options.merge!(marshal: true, :allow_empty_value => true)
  attr_encrypted :caseid, key: Base64.decode64('Q0Y9LHHPTFuCu/Cjn/FztKjsmoVVek8jrqaNkAZiwoo=\n')
  attr_encrypted :cellphonenumber, key: Base64.decode64('9hEbxCqudwTj20XCafmQ1olK+J7BMJdiS44rq4IRsGg=\n')
end
