require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    where_line = params.map { |k,_| "#{k} = ?" }
    where_line = where_line.join(" AND ")
    values = params.map { |_,v| v }

    DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

  end
end

class SQLObject
  extend Searchable
end
