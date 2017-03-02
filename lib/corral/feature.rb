module Corral
  class Feature
    attr_reader :condition, :disabled

    def initialize(feature, condition, disabled)
      @feature = feature
      @condition = condition
      @disabled = disabled
    end

    class << self
      def features
        @features ||= {}
      end

      def push(name, condition, disabled = true)
        features[name] = new(name, condition, disabled)
      end

      def enable(name, condition)
        push(name, condition, false)
      end

      def disable(name, condition)
        push(name, condition, true)
      end

      def get(name)
        features[name]
      end

      def all
        features
      end
    end
  end
end
