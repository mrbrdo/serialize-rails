require 'test_helper'
require 'serialize-rails/coders/xml_column'

module ActiveRecord
  module Coders
    class XMLColumnTest < ActiveSupport::TestCase
      XML_NIL = Ox.dump(nil)
      XML_EMPTY_HASH = Ox.dump({})

      def test_initialize_takes_class
        coder = XMLColumn.new(Object)
        assert_equal Object, coder.object_class
      end

      def test_type_mismatch_on_different_classes_on_dump
        coder = XMLColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.dump("a")
        end
      end

      def test_type_mismatch_on_different_classes
        coder = XMLColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.load XML_EMPTY_HASH
        end
      end

      def test_nil_is_ok
        coder = XMLColumn.new
        assert_nil coder.load XML_NIL
      end

      def test_returns_new_with_different_class
        coder = XMLColumn.new SerializationTypeMismatch
        assert_equal SerializationTypeMismatch, coder.load(XML_NIL).class
      end

      def test_load_handles_other_classes
        coder = XMLColumn.new
        assert_equal [], coder.load([])
      end

      def test_load_swallows_xml_exceptions
        coder = XMLColumn.new
        bad_xml = 'x'
        assert_equal bad_xml, coder.load(bad_xml)
      end
    end
  end
end
