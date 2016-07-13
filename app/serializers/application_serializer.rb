class ApplicationSerializer < ActiveModel::Serializer
  def self.parse(model)
    self.new(model).to_hash
  end
end
