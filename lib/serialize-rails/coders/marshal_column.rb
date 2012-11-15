module ActiveRecord
  module Coders # :nodoc:
    class MarshalColumn # :nodoc:
      RESCUE_ERRORS = [ ArgumentError, TypeError ]

      attr_accessor :object_class

      def initialize(object_class = Object)
        @object_class = object_class
      end

      def dump(obj)
        return if obj.nil?

        unless obj.is_a?(object_class)
          raise SerializationTypeMismatch,
            "Attribute was supposed to be a #{object_class}, but was a #{obj.class}. -- #{obj.inspect}"
        end
        Marshal.dump obj
      end

      def load(data)
        return object_class.new if object_class != Object && data.nil?
        return data unless data.is_a?(String)
        begin
          obj = Marshal.load(data)

          unless obj.is_a?(object_class) || obj.nil?
            raise SerializationTypeMismatch,
              "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
          end
          obj ||= object_class.new if object_class != Object

          obj
        rescue *RESCUE_ERRORS
          data
        end
      end
    end
  end
end
