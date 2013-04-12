require "corral/version"

module Corral
  class Feature
    attr_accessor :feature, :condition, :disabled

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

  def corral(&block)
    instance_eval(&block)
  end

  def disabled?(feature, argument = nil)
    !enabled?(feature, argument)
  end

  def enabled?(feature, argument = nil)
    feature = Feature.get(feature)
    return false unless feature && (condition = feature.condition)

    if argument
      !condition.call(argument)
    else
      !condition.call
    end
  end

  def hide(feature, options = {})
    condition = options[:when] || options[:if]

    if condition && !condition.respond_to?(:call)
      raise "'when' or 'if' condition must be a callable object"
    end

    Feature.push(feature, condition)
  end
end
