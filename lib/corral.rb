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
    instance_eval(&block)
  end

  def self.disable(feature, options = {})
    flip_feature(feature, options.merge(enable: false))
  end

  def self.enable(feature, options = {})
    flip_feature(feature, options.merge(enable: true))
  end

  def self.disabled?(feature, *arguments)
    !self.enabled?(feature, *arguments)
  end

  def self.enabled?(feature, *arguments)
    (feature = Feature.get(feature)) && (condition = feature.condition) or
      return false

    call_condition(feature, condition, *arguments)
  end

  private

  def self.environment_override(feature, enable, *environments)
    envs = environments.map(&:to_sym)
    condition = -> { envs.any? { |env| env == self.environment } }
    push_feature(enable, feature, condition)
  end

  def self.process_condition(options = {})
    condition = options[:when] || options[:if]
    default = -> { true }

    (condition && !condition.respond_to?(:call)) and
      raise "'when' or 'if' condition must be a callable object"

    condition || default
  end

  def self.flip_feature(feature, options = {})
    enable = options[:enable]
    environments = options[:in] and
      return environment_override(feature, enable, *environments)

    condition = process_condition(options)

    push_feature(enable, feature, condition)
  end

  def self.push_feature(enable, feature, condition)
    if enable
      Feature.enable(feature, condition)
    else
      Feature.disable(feature, condition)
    end
  end

  def self.call_condition(feature, condition, *arguments)
    if feature.disabled
      !condition.call(*arguments)
    else
      condition.call(*arguments)
    end
  end
end
