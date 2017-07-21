require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    if @columns.nil?
      cols_queury = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          '#{self.table_name}'
      SQL
      @columns = cols_queury[0].map(&:to_sym)
    else
      @columns
    end
  end

  # c_set = "#{col}="
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
    if @all.nil?
      all_query = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL
      @all = all_query
    else
      @all
    end
    self.parse_all(@all)
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
        id = ?
    SQL
    self.new(item.first) unless item.empty?
  end

  def initialize(params = {})
    params.each do |k,v|
      unless self.class.columns.include?(k.to_sym)
        raise Exception.new("unknown attribute '#{k}'")
      end
      k = "#{k}=".to_sym
      self.send(k, v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.map { |k,v| v }
  end

  def insert
    columns = []
    values = []
    attributes.each do |k,v|
      columns << k
      values << v
    end
    v = values.join(", ")
    c = columns.join(", ")
    qs = Array.new(columns.length, '?').join(", ")

    DBConnection.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table_name} (#{c})
      VALUES
        (#{qs})
    SQL
    self.id = DBConnection.instance.last_insert_row_id
  end

  def update

    columns = []
    values = []
    attributes.each do |k,v|
      columns << "#{k} = ?"
      values << v
    end
    c = columns.join(", ")


    DBConnection.execute(<<-SQL, *values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{c}
      WHERE
        id = ?
    SQL
  end

  def save
    debugger
    # self.instance_variables.empty? ? insert : update
    self.id.nil? ? insert : update

  end
end
