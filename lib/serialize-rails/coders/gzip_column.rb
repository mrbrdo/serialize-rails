require 'zlib'

module ActiveRecord
  module Coders # :nodoc:
    class GzipColumn # :nodoc:
      RESCUE_ERRORS = [ ArgumentError ]

      attr_accessor :wrapped_coder

      def initialize(wrap_coder)
        @wrapped_coder = wrap_coder
      end

      def object_class
        wrapped_coder.object_class
      end

      def object_class=(value)
        wrapped_coder.object_class = value
      end

      def dump(obj)
        obj = wrapped_coder.dump(obj)
        return if obj.nil?
        return obj unless obj.is_a?(String)

        Zlib::Deflate.deflate obj
      end

      def load(data)
        return object_class.new if object_class != Object && data.nil?
        return data unless data.is_a?(String)
        begin
          ungzipped_data = Zlib::Inflate.inflate(data)
          wrapped_coder.load(ungzipped_data)
        rescue *RESCUE_ERRORS
          data
        end
      end
    end
  end
end
