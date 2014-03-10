module Corral
  class Feature
    attr_reader :condition

    def initialize(feature, condition, disabled)
      @feature = feature
      @condition = condition
      @disabled = disabled
    end

    def self.push(name, condition, disabled = true)
      @features ||= {}
      @features[name] = new(name, condition, disabled)
    end

    def self.get(name)
      (@features ||= {})[name]
    end
  end
end
