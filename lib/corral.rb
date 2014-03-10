require "corral/version"
require "corral/helpers"

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

  def self.environment
    @environment
  end

  def self.environment=(env)
    @environment = env.to_sym
  end

  def self.corral(env = nil, &block)
    self.environment = env.to_s
    gather_features(&block)
  end

  def self.disable(feature, options = {})
    environments = options[:in] and
      return environment_override(feature, *environments)

    condition = options[:when] || options[:if]

    if condition && !condition.respond_to?(:call)
      raise "'when' or 'if' condition must be a callable object"
    end

    Feature.push(feature, condition)
  end

  def self.disabled?(feature, argument = nil)
    !self.enabled?(feature, argument)
  end

  def self.enabled?(feature, argument = nil)
    feature = Feature.get(feature)
    return false unless feature && (condition = feature.condition)

    if argument
      !condition.call(argument)
    else
      !condition.call
    end
  end

  private

  def self.gather_features(&block)
    instance_eval(&block)
  end

  def self.environment_override(feature, *environments)
    condition = -> do
      environments.any? { |env| env.to_sym == self.environment }
    end

    Feature.push(feature, condition)
  end
end
