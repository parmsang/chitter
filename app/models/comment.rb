require 'dm-timestamps'
require 'data_mapper'

class Comment

  include DataMapper::Resource

  property :id,        Serial
  property :text,      Text, required: true
  property :timestamp, DateTime, required: true

  belongs_to :peep
  belongs_to :user

end
