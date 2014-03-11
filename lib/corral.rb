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

    (condition && !condition.respond_to?(:call)) and
      raise "'when' or 'if' condition must be a callable object"

    Feature.push(feature, condition)
  end

  def self.disabled?(feature, *arguments)
    !self.enabled?(feature, *arguments)
  end

  def self.enabled?(feature, *arguments)
    (feature = Feature.get(feature)) && (condition = feature.condition) or
      return false

    !condition.call(*arguments)
  end

  private

  def self.gather_features(&block)
    instance_eval(&block)
  end

  def self.environment_override(feature, *environments)
    envs = environments.map(&:to_sym)
    condition = -> { envs.any? { |env| env == self.environment } }
    Feature.push(feature, condition)
  end
end
