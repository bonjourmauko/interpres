class Resource < ActiveRecord::Base
  validates :resource_id,
            :presence => true,
            :uniqueness => true
  
end