module Corral
  class Feature
    attr_reader :condition, :disabled

    def initialize(feature, condition, disabled)
      @feature = feature
      @condition = condition
      @disabled = disabled
    end

    def self.push(name, condition, disabled = true)
      @features ||= {}
      @features[name] = new(name, condition, disabled)
    end

    def self.enable(name, condition)
      push(name, condition, false)
    end

    def self.disable(name, condition)
      push(name, condition, true)
    end

    def self.get(name)
      (@features ||= {})[name]
    end
  end
end
