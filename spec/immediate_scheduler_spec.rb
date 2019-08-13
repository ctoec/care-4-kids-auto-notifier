require 'rails_helper'

RSpec.describe ImmediateScheduler do
    it '.getNextTime returns a time close to now' do
      expect(ImmediateScheduler.getNextTime()).to be_within(1.second).of(Time.now)
    end
end
