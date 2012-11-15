require 'test_helper'
require 'active_record_helper'
require 'serialize-rails/coders/gzip_column'
require 'serialize-rails/coders/json_column'
require 'serialize-rails/serialization'

# mostly already tested in AR tests, and did not change much
class SerializationTest < ActiveSupport::TestCase
  def teardown
    clean_db
  end

  def test_defaults_to_yaml
    MouseDefaults.create! :info => { 1 => "x" }
    assert_equal("---\n1: x\n", get_raw_info)
  end

  def test_yaml_array
    assert_raises(ActiveRecord::SerializationTypeMismatch) do
      MouseDefaultsArray.create! :info => { 1 => "x" }
    end
  end

  def test_json_array
    MouseJsonArray.create! :info => Array.new
    assert_equal("[]", get_raw_info.gsub(/\s+/, ""))
  end

  def test_json_array_gzip
    test_array = ["hello"] * 5
    MouseJsonArrayGzip.create! :info => test_array
    json_for_array = ActiveRecord::Coders::JSONColumn.new(Array).dump(test_array)
    assert_operator get_raw_info.length, :<, json_for_array.length
  end
end
