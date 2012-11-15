require 'json'

module ActiveRecord
  module Coders # :nodoc:
    class JSONColumn # :nodoc:
      RESCUE_ERRORS = [ ArgumentError, JSON::JSONError ]

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
        JSON.dump obj
      end

      def load(json)
        return object_class.new if object_class != Object && json.nil?
        return json unless json.is_a?(String)
        begin
          obj = JSON.load(json)

          unless obj.is_a?(object_class) || obj.nil?
            raise SerializationTypeMismatch,
              "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
          end
          obj ||= object_class.new if object_class != Object

          obj
        rescue *RESCUE_ERRORS
          json
        end
      end
    end
  end
end
