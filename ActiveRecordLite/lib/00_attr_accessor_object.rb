require 'byebug'

class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      n = "@#{name}"
      setter = "#{name}="

      define_method(name) do
        self.instance_variable_get(n)
      end

      define_method(setter) do |val|
        self.instance_variable_set(n, val)
      end
    end
  end
end
