ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false
load "schema.rb"

def get_raw_info
  raw_data = ActiveRecord::Base.connection.select_all("SELECT info FROM mice")
  raw_data.first["info"]
end

def clean_db
  ActiveRecord::Base.connection.select_all("DELETE FROM mice")
end
