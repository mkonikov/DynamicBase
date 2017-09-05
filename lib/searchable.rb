require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    where_line = params.map { |k,_| "#{k} = ?" }.join(" AND ")
    values = params.map { |_,v| v }

    data = DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    # self.parse_all(data)

  end
end

class SQLObject
  extend Searchable
end
