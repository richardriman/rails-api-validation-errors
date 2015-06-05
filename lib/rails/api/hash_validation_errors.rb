module Rails::API::HashValidationErrors

  def self.included(base)
    base.send :around_filter, :use_hash_validation_errors
  end

  def use_hash_validation_errors(&block)
    ActiveModel::Errors.enable_extended_errors
    yield
  ensure
    ActiveModel::Errors.disable_extended_errors
  end

end
