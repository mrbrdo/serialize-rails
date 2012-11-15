ActiveRecord::Schema.define(:version => 0) do
  create_table :mice, :force => true do |t|
    t.text :info
  end
end

class MouseDefaults < ActiveRecord::Base
  self.table_name = "mice"
  serialize :info
end

class MouseDefaultsArray < ActiveRecord::Base
  self.table_name = "mice"
  serialize :info, Array
end

class MouseJsonArray < ActiveRecord::Base
  self.table_name = "mice"
  serialize :info, Array, :format => :json
end

class MouseJsonArrayGzip < ActiveRecord::Base
  self.table_name = "mice"
  serialize :info, Array, :format => :json, :gzip => true
end
