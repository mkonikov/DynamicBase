require_relative 'searchable'
require 'active_support/inflector'
require 'byebug'

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
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
