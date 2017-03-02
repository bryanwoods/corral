require 'spec_helper'

describe Corral::Feature do
  include Corral::Helpers

  describe ".all" do
    context "when no features have been corralled" do
      it "is an empty hash" do
        expect(Corral::Feature.all).to eq({})
      end
    end

    context "when one or more features have been corralled" do
      before do
        corral do
          enable :everything_free
          disable :torpedoes
        end
      end

      it "is list of every feature" do
        expect(Corral::Feature.all.keys).to eq([:everything_free, :torpedoes])
      end
    end
  end
end
