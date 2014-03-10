module Corral
  module Helpers
    %w(corral disable enabled? disabled?).each do |name|
      class_eval <<-EOS
        def #{name}(*args, &block)
          Corral.#{name}(*args, &block)
        end
      EOS
    end
  end
end
