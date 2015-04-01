require "hash_accessor/version"

module HashAccessor
  def self.included(base)
    base.send(:attr_accessor, :hash_attributes)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def hash_accessor(*attribute_names, **options)
      accessor_options = if class_variable_defined?(:@@hash_accessor_options)
        class_variable_get(:@@hash_accessor_options)
      else
        {}
      end

      accessor_options.merge!(options)
      class_variable_set(:@@hash_accessor_options, accessor_options)

      accessors = if class_variable_defined?(:@@hash_accessors)
        class_variable_get(:@@hash_accessors)
      else
        []
      end

      accessors += attribute_names
      class_variable_set(:@@hash_accessors, accessors)

      define_method(:initialize) do |*args|
        self.hash_attributes = {}
        attributes = args.first || {}
        assign_hash_attributes attributes
      end

      define_method(:assign_hash_attributes) do |attributes|
        attributes.each_pair do |key, value|
          attribute = key.to_sym
          if self.class.__hash_accessors.member?(attribute)
            send("#{attribute}=", value)
          elsif self.class.__hash_accessor_options.fetch(:strict) { false }
            raise ArgumentError,
              "Supplied key '#{attribute.inspect}' is not a valid" +
              " hash accessor for #{self.class.inspect}"
          else
            hash_attributes[attribute] = value
          end
        end
        self
      end

      attribute_names.each do |name|
        define_method(name) do
          hash_attributes[name]
        end

        define_method("#{name}=") do |value|
          hash_attributes[name] = value
        end
      end
    end
    alias_method :hash_accessors, :hash_accessor

    def __hash_accessors
      class_variable_get(:@@hash_accessors)
    end

    def __hash_accessor_options
      class_variable_get(:@@hash_accessor_options)
    end
  end

end
