class Applicant < ApplicationRecord
  @@CASEID_ENCRYPTION_KEY = Base64.decode64 ENV.fetch 'CASEID_ENCRYPTION_KEY'
  @@CELLPHONENUMBER_ENCRYPTION_KEY = Base64.decode64 ENV.fetch 'CELLPHONENUMBER_ENCRYPTION_KEY'

  attr_encrypted_options.merge!(marshal: true, :allow_empty_value => true)

  attr_encrypted :caseid, key: @@CASEID_ENCRYPTION_KEY
  attr_encrypted :cellphonenumber, key: @@CELLPHONENUMBER_ENCRYPTION_KEY
end
