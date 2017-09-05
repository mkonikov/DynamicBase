require_relative 'searchable'
require_relative 'dynamic_connection'
require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".downcase.to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name}".camelcase
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name}_id".downcase.to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name}".camelcase.singularize
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] =
      BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key_value = self.send(options.foreign_key)

      options.model_class
        .where(options.primary_key => foreign_key_value)
        .first
    end

  end

  def has_many(name, options = {})
    self.assoc_options[name] =
      HasManyOptions.new(name, self.name, options)

    define_method(name) do
      options = self.class.assoc_options[name]
      primary_key_value = self.send(options.primary_key)

      options.model_class
        .where(options.foreign_key => primary_key_value)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      thru_table = through_options.table_name
      thru_fk = through_options.foreign_key
      thru_pk = through_options.primary_key

      src_table = source_options.table_name
      src_fk = source_options.foreign_key
      src_pk = source_options.primary_key

      key_val = self.send(thru_fk)

      data = DynamicConnection.execute(<<-SQL, key_val)
        SELECT
          #{src_table}.*
        FROM
          #{thru_table}
        JOIN
          #{src_table}
        ON
          #{thru_table}.#{src_fk} = #{src_table}.#{src_pk}
        WHERE
          #{thru_table}.#{thru_pk} = ?

      SQL

      source_options.model_class.parse_all(data).first

    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end
