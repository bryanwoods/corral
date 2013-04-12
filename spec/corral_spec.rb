require 'spec_helper'

describe Corral do
  include Corral

  describe "#corral" do
    context "when given a block" do
      it "yields the block" do
        corral { :cool_feature }.should == :cool_feature
      end

      context "when given known features" do
        context "when given callable 'when' or 'if' options" do
          context "when the conditions are true" do
            before do
              corral do
                disable :everything_free, when: -> { true }
                disable :torpedoes, if: -> { true }
              end
            end

            it "is disabled" do
              disabled?(:everything_free).should be_true
              disabled?(:torpedoes).should be_true
            end
          end

          context "when the conditions are not true" do
            before do
              corral do
                disable :payment_button, when: -> { 1 > 2 }
                disable :sunshine, if: -> { true == false }
              end
            end

            it "is enabled" do
              enabled?(:payment_button).should be_true
              enabled?(:sunshine).should be_true
            end
          end
        end

        context "when the 'when' or 'if' condition is not callable" do
          it "raises an exception" do
            expect do
              corral do
                disable :the_sandwich, if: 1.odd?
              end
            end.to raise_error(RuntimeError)
          end
        end

        context "when not given a 'when' or 'if' condition" do
          it "is disabled" do
            corral { :my_feature }
            disabled?(:my_feature).should be_true
          end
        end
      end
    end

    context "when not given a block" do
      it "raises an error" do
        expect { corral }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#enabled?" do
    context "when the given feature exists" do
      context "when the feature has no 'when' condition" do
        before do
          corral do
            disable :torpedoes
          end
        end

        it "is false" do
          enabled?(:torpedoes).should be_false
        end
      end

      context "when the feature has a 'when' condition" do
        context "when the 'when' condition is true" do
          before do
            corral do
              disable :torpedoes, when: -> { true }
            end
          end

          it "is false" do
            enabled?(:torpedoes).should be_false
          end
        end

        context "when the 'when' condition is false" do
          before do
            corral do
              disable :cupcakes, when: -> { false }
            end
          end

          it "is true" do
            enabled?(:cupcakes).should be_true
          end
        end
      end
    end

    context "when the given feature does not exist" do
      it "is false" do
        enabled?(:unknown_feature).should be_false
      end
    end

    context "when given an argument to test against" do
      context "when the result is true" do
        before do
          corral do
            disable :cupcakes, if: ->(person) { person == "Bryan" }
          end
        end

        it "is false" do
          enabled?(:cupcakes, "Bryan").should be_false
        end
      end

      context "when the result is not true" do
        before do
          corral do
            disable :cupcakes, if: ->(person) { person == "Bryan" }
          end
        end

        it "is false" do
          enabled?(:cupcakes, "George").should be_true
        end
      end
    end
  end

  describe "#disabled?" do
    context "when the given feature exists" do
      context "when the feature has no 'when' condition" do
        before do
          corral do
            disable :torpedoes
          end
        end

        it "is true" do
          disabled?(:torpedoes).should be_true
        end
      end

      context "when the feature has a 'when' condition" do
        context "when the 'when' condition is true" do
          before do
            corral do
              disable :torpedoes, when: -> { true }
            end
          end

          it "is true" do
            disabled?(:torpedoes).should be_true
          end
        end

        context "when the 'when' condition is false" do
          before do
            corral do
              disable :cupcakes, when: -> { false }
            end
          end

          it "is false" do
            disabled?(:cupcakes).should be_false
          end
        end
      end
    end

    context "when the given feature does not exist" do
      it "is true" do
        disabled?(:unknown_feature).should be_true
      end
    end
  end

  context "when given an argument to test against" do
    context "when the result is true" do
      before do
        corral do
          disable :cupcakes, if: ->(person) { person == "Bryan" }
        end
      end

      it "is true" do
        disabled?(:cupcakes, "Bryan").should be_true
      end
    end

    context "when the result is not true" do
      before do
        corral do
          disable :cupcakes, if: ->(person) { person == "Bryan" }
        end
      end

      it "is false" do
        disabled?(:cupcakes, "George").should be_false
      end
    end
  end
end
