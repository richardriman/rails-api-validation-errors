# Monkey patch ActiveModel::Errors class to return a hash containing translation
# key and options if translation is missing.
module ActiveModel
  class Errors

    # Option to specify wether to return hash or translation. Defaults to translation (false)
    # to keep original behaviour.
    @@extended_errors = false

    def self.disable_extended_errors
      @@extended_errors = false
    end

    def self.enable_extended_errors
      @@extended_errors = true
    end

    # Keep original method
    alias _generate_message generate_message

    def generate_message(attribute, type = :invalid, options = {})
      message = _generate_message(attribute, type, options)
      return message unless @@extended_errors

      type = options[:message] if options[:message].is_a?(Symbol)
      { type: type, message: message, meta: options }
    end

  end
end
