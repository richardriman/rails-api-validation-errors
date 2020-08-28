# frozen_string_literal: true

module Rails::API::HashValidationErrors
  def self.included(base)
    base.send(base.respond_to?(:around_action) ? :around_action : :around_filter, :use_hash_validation_errors)
  end

  def use_hash_validation_errors
    ActiveModel::Errors.enable_extended_errors
    yield
  ensure
    ActiveModel::Errors.disable_extended_errors
  end
end
