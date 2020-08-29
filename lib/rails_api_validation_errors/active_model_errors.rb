# frozen_string_literal: true

require 'request_store_rails'

# Monkey patch ActiveModel::Errors class to return a hash containing translation
# key and options if translation is missing.
module ActiveModel
  class Errors
    def self.disable_extended_errors
      RequestLocals.store[:extended_errors] = false
    end

    def self.enable_extended_errors
      RequestLocals.store[:extended_errors] = true
    end

    def extended_errors_enabled?
      RequestLocals.store[:extended_errors] || false
    end

    # Keep original method
    alias _generate_message generate_message

    def generate_message(attribute, type = :invalid, options = {})
      message = _generate_message(attribute, type, options)
      return message unless extended_errors_enabled?

      type = options[:message] if options[:message].is_a?(Symbol)

      res = { type: type, message: message, meta: options }
      res[:code] = options.delete(:code) if options[:code]
      res
    end
  end
end
