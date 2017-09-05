require_relative 'dynamic_connection'
require_relative 'base'

module Searchable
  def where(params)
    where_line = params.map { |k,_| "#{k} = ?" }.join(" AND ")

    data = DynamicConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    self.parse_all(data)

  end
end
