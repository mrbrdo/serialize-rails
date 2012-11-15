require 'test_helper'
require 'serialize-rails/coders/gzip_column'
require 'serialize-rails/coders/json_column'

module ActiveRecord
  module Coders
    class JSONColumnTest < ActiveSupport::TestCase
      def test_initialize_takes_class
        coder = GzipColumn.new(JSONColumn.new(Object))
        assert_equal Object, coder.object_class
      end

      def test_gzip_works
        json_coder = JSONColumn.new(Object)
        coder = GzipColumn.new(json_coder)

        test_array = ["hello"] * 5
        json_output = json_coder.dump(test_array)
        gzipped_output = coder.dump(test_array)
        assert_operator json_output.length, :>, gzipped_output.length
      end

      def test_dump_and_load
        coder = GzipColumn.new(JSONColumn.new(Object))
        assert_equal([1, "x"], coder.load(coder.dump([1, "x"])))
      end
    end
  end
end
