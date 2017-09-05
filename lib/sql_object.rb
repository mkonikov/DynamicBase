require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject

  def self.columns
    if @columns.nil?
      cols_query = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          '#{self.table_name}'
        LIMIT
          0
      SQL
      @columns = cols_query.first.map(&:to_sym)
    else
      @columns
    end
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end

      define_method("#{col}=") do |val|
        self.attributes[col] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    all_query = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(all_query)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    item = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = :id
    SQL
    self.new(item.first) unless item.empty?
  end

  def initialize(params = {})
    params.each do |k,v|
      unless self.class.columns.include?(k.to_sym)
        raise Exception.new("Unknown attribute '#{k}'")
      end
      k = "#{k}=".to_sym
      self.send(k, v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col| self.send(col) }
  end

  def insert
    columns = self.class.columns.drop(1)
    c = columns.join(", ")
    qs = Array.new(columns.length, '?').join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{c})
      VALUES
        (#{qs})
    SQL
    self.id = DBConnection.instance.last_insert_row_id
  end

  def update
    columns = self.class.columns.map { |attr| "#{attr} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end
