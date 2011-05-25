class Email < ActiveRecord::Base
  validates :href,
            :presence => true,
            :uniqueness => true
  
  validates :from,
            :presence => true
end