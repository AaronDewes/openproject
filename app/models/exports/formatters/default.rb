module Exports
  module Formatters
    class Default
      include Redmine::I18n

      attr_reader :attribute

      def initialize(attribute)
        @attribute = attribute
      end

      ##
      # Checks if this column is applicable for this column
      def self.apply?(_attribute)
        false
      end

      def self.key
        name.demodulize.underscore.to_sym
      end

      ##
      # Takes a resource and an attribute and returns the value to be exported.
      def format(object, **options)
        value = object.try(attribute)

        case value
        when Date
          format_date value
        when Time, DateTime, ActiveSupport::TimeWithZone
          format_time value
        when Array
          value.join options.fetch(:array_separator, ', ')
        when nil
          # ruby >=2.7.1 will return a frozen string for nil.to_s which will cause an error when e.g. trying to
          # force an encoding
          ''
        else
          value.to_s
        end
      end

      ##
      # Takes an attribute and returns format options for it.
      def format_options
        {}
      end
    end
  end
end
