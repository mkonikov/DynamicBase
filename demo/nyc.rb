require_relative '../lib/base'

DynamicConnection.reset

class Borough < Base
  has_many :neighborhoods
  finalize!
end

class Neighborhood < Base
  belongs_to :borough
  has_many :sights
  finalize!
end

class Sight < Base
  belongs_to :neighborhood
  has_one_through :borough, :neighborhood, :borough
  finalize!
end
