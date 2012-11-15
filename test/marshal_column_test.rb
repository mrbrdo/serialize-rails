require 'test_helper'
require 'serialize-rails/coders/marshal_column'

module ActiveRecord
  module Coders
    class MarshalColumnTest < ActiveSupport::TestCase
      def test_initialize_takes_class
        coder = MarshalColumn.new(Object)
        assert_equal Object, coder.object_class
      end

      def test_type_mismatch_on_different_classes_on_dump
        coder = MarshalColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.dump("a")
        end
      end

      def test_type_mismatch_on_different_classes
        coder = MarshalColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.load Marshal.dump(Hash.new)
        end
      end

      def test_nil_is_ok
        coder = MarshalColumn.new
        assert_nil coder.load Marshal.dump(nil)
      end

      def test_returns_new_with_different_class
        coder = MarshalColumn.new SerializationTypeMismatch
        assert_equal SerializationTypeMismatch, coder.load(Marshal.dump(nil)).class
      end

      def test_load_handles_other_classes
        coder = MarshalColumn.new
        assert_equal [], coder.load([])
      end

      def test_load_swallows_marshal_exceptions
        coder = MarshalColumn.new
        bad_marshal = '{}'
        assert_equal bad_marshal, coder.load(bad_marshal)
      end
    end
  end
end
