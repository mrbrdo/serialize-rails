# Must trigger autoloading of the class
if ActiveRecord::AttributeMethods::Serialization.nil?
  raise "ActiveRecord not loaded"
end

module ActiveRecord
  module AttributeMethods
    module Serialization
      module ClassMethods
        # If you have an attribute that needs to be saved to the database as an
        # object, and retrieved as the same object, then specify the name of that
        # attribute using this method and it will be handled automatically. The
        # serialization is done through YAML. If +class_name+ is specified, the
        # serialized object must be of that class on retrieval or
        # <tt>SerializationTypeMismatch</tt> will be raised.
        #
        # ==== Parameters
        #
        # * +attr_name+ - The field name that should be serialized.
        # * +class_name+ - Optional, class name that the object type should be equal to.
        #
        # ==== Example
        #
        #   # Serialize a preferences attribute.
        #   class User < ActiveRecord::Base
        #     serialize :preferences
        #   end
        def serialize(attr_name, *args)
          include Behavior if defined? Behavior # Rails 4

          options = args.shift
          if options.is_a? Hash
            class_name = Object
          else
            class_name = options || Object
            options = args.shift || Hash.new
          end

          default_options = {
            :format => :yaml,
            :gzip => false
          }
          options = default_options.merge(options)

          coder = if [:load, :dump].all? { |x| class_name.respond_to?(x) }
                    class_name
                  else
                    upcase_formats = [:json, :xml, :yaml]
                    coder_class = if upcase_formats.include?(options[:format])
                      options[:format].to_s.upcase
                    else
                      options[:format].to_s.camelize
                    end
                    coder_class = begin
                      "ActiveRecord::Coders::#{coder_class}Column".constantize
                    rescue
                      Coders::YAMLColumn
                    end
                    coder_class.new(class_name)
                  end

          coder = Coders::GzipColumn.new(coder) if options[:gzip]

          # merge new serialized attribute and create new hash to ensure that each class in inheritance hierarchy
          # has its own hash of own serialized attributes
          self.serialized_attributes = serialized_attributes.merge(attr_name.to_s => coder)
        end
      end
    end
  end
end
