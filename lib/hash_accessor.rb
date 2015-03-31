require "hash_accessor/version"

module HashAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def hash_accessor(*attribute_names, **options)
      strict = options.fetch(:strict) { false }

      define_method(:initialize) do |**attributes|
        @hash_attributes = attributes

        if strict
          invalid = attributes.keys.detect do |key|
            !attribute_names.member?(key)
          end
          if invalid
            raise ArgumentError,
              "Supplied key '#{invalid.inspect}' is not a valid hash accessor for #{self.inspect}"
          end
        end
      end

      attribute_names.each do |name|
        define_method(name) do
          @hash_attributes[name]
        end

        define_method("#{name}=") do |value|
          @hash_attributes[name] = value
        end
      end

    end
  end
end
