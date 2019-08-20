class UninitializedClassSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(arg)
    arg.is_a? Class
  end

  def serialize(klass)
    super(
      "classname" => klass.to_s
    )
  end

  def deserialize(hash)
    Object.const_get(hash["classname"])
  end
end