# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UninitializedClassSerializer do
  before(:all) do
    class Klass
      @@id = 1
    end
  end

  it 'compose of serialization and deserialization is identity function' do
    expect(
      UninitializedClassSerializer.deserialize(
        UninitializedClassSerializer.serialize(
          Klass
        )
      )
    ).to eq Klass
  end
end
