require 'ox'

module ActiveRecord
  module Coders # :nodoc:
    class XMLColumn # :nodoc:
      RESCUE_ERRORS = [ ArgumentError, SyntaxError, Ox::ParseError ]

      attr_accessor :object_class, :options

      def initialize(object_class = Object, options = nil)
        @object_class = object_class
        @options = options || Hash.new
        default_options = { :load => Hash.new, :dump => Hash.new }
        @options = default_options.merge(@options)
      end

      def dump(obj)
        return if obj.nil?

        unless obj.is_a?(object_class)
          raise SerializationTypeMismatch,
            "Attribute was supposed to be a #{object_class}, but was a #{obj.class}. -- #{obj.inspect}"
        end
        Ox.dump(obj, options[:dump])
      end

      def load(xml)
        return object_class.new if object_class != Object && xml.nil?
        return xml unless xml.is_a?(String)
        begin
          default_load_opts = { :mode => :object }
          obj = Ox.load(xml, default_load_opts.merge(options[:load]))

          unless obj.is_a?(object_class) || obj.nil?
            raise SerializationTypeMismatch,
              "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
          end
          obj ||= object_class.new if object_class != Object

          obj
        rescue *RESCUE_ERRORS
          xml
        end
      end
    end
  end
end
