require "corral/version"
require "corral/feature"
require "corral/helpers"

module Corral
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
