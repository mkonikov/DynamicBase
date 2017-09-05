require_relative 'lib/sql_object'

DynamicConnection.reset

class Borough < SQLObject
  has_many :neighborhoods
  finalize!
end

class Neighborhood < SQLObject
  belongs_to :borough
  has_many :sights
  finalize!
end

class Sight < SQLObject
  belongs_to :neighborhood
  has_one_through :borough, :neighborhood, :borough
  finalize!
end
