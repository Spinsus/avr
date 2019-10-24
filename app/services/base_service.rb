class BaseService
  attr_reader :data

  def self.call(*args)
    new(*args).call
  end

  def call
    payload
    self
  end

  def success?
    errors.empty?
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end
end
