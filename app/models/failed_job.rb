class FailedJob < ApplicationRecord
  belongs_to :notification
  belongs_to :parent
end
