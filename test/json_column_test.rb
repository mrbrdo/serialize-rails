require 'test_helper'
require 'serialize-rails/coders/json_column'

module ActiveRecord
  module Coders
    class JSONColumnTest < ActiveSupport::TestCase
      def test_initialize_takes_class
        coder = JSONColumn.new(Object)
        assert_equal Object, coder.object_class
      end

      def test_type_mismatch_on_different_classes_on_dump
        coder = JSONColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.dump("a")
        end
      end

      def test_type_mismatch_on_different_classes
        coder = JSONColumn.new(Array)
        assert_raises(SerializationTypeMismatch) do
          coder.load "{}"
        end
      end

      def test_nil_is_ok
        coder = JSONColumn.new
        assert_nil coder.load "null"
      end

      def test_returns_new_with_different_class
        coder = JSONColumn.new SerializationTypeMismatch
        assert_equal SerializationTypeMismatch, coder.load("null").class
      end

      def test_load_handles_other_classes
        coder = JSONColumn.new
        assert_equal [], coder.load([])
      end

      def test_load_swallows_json_exceptions
        coder = JSONColumn.new
        bad_json = 'x'
        assert_equal bad_json, coder.load(bad_json)
      end
    end
  end
end
