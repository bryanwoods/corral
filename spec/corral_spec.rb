require 'spec_helper'

describe Corral do
  include Corral::Helpers

  describe ".corral" do
    context "when given a block" do
      it "yields the block" do
        expect(corral { :cool_feature }).to eq(:cool_feature)
      end

      context "when given known features" do
        context "when passed an environment in an 'in' option" do
          context "when the environment matches the condition" do
            before do
              corral("development") do
                disable :caching, in: :development
                enable "expiry_headers", in: :development
              end
            end

            it "disables the feature" do
              expect(disabled?(:caching)).to be true
              expect(enabled?("expiry_headers")).to be true
            end
          end

          context "when the environment does not match any of the conditions" do
            before do
              corral("development") do
                disable :debug_mode, in: [:production, :test]
              end
            end

            it "does not disable the feature" do
              expect(disabled?(:debug_mode)).to be false
            end
          end
        end

        context "when given callable 'when' or 'if' options" do
          context "when the conditions are true" do
            before do
              corral do
                disable :everything_free, when: -> { true }
                disable :torpedoes, if: -> { true }
              end
            end

            it "is disabled" do
              expect(disabled?(:everything_free)).to be true
              expect(disabled?(:torpedoes)).to be true
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
              expect(enabled?(:payment_button)).to be true
              expect(enabled?(:sunshine)).to be true
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
            corral do
              :my_feature
              disable :my_other_feature
            end

            expect(disabled?(:my_feature)).to be true
            expect(disabled?(:my_other_feature)).to be true
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
          expect(enabled?(:torpedoes)).to be false
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
            expect(enabled?(:torpedoes)).to be false
          end
        end

        context "when the 'when' condition is false" do
          before do
            corral do
              disable :cupcakes, when: -> { false }
            end
          end

          it "is true" do
            expect(enabled?(:cupcakes)).to be true
          end
        end
      end
    end

    context "when the given feature does not exist" do
      it "is false" do
        expect(enabled?(:unknown_feature)).to be false
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
          expect(enabled?(:cupcakes, "Bryan")).to be false
        end
      end

      context "when the result is not true" do
        before do
          corral do
            disable :cupcakes, if: ->(person) { person == "Bryan" }
          end
        end

        it "is false" do
          expect(enabled?(:cupcakes, "George")).to be true
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
          expect(disabled?(:torpedoes)).to be true
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
            expect(disabled?(:torpedoes)).to be true
          end
        end

        context "when the 'when' condition is false" do
          before do
            corral do
              disable :cupcakes, when: -> { false }
            end
          end

          it "is false" do
            expect(disabled?(:cupcakes)).to be false
          end
        end
      end
    end

    context "when the given feature does not exist" do
      it "is true" do
        expect(disabled?(:unknown_feature)).to be true
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
        expect(disabled?(:cupcakes, "Bryan")).to be true
      end
    end

    context "when the result is not true" do
      before do
        corral do
          disable :cupcakes, if: ->(person) { person == "Bryan" }
        end
      end

      it "is false" do
        expect(disabled?(:cupcakes, "George")).to be false
      end
    end
  end

  describe ".enable" do
    context "when not given if or when conditions" do
      before do
        corral do
          enable :always_on
        end
      end

      it "enables the feature" do
        expect(enabled?(:always_on)).to be true
      end
    end

    context "when given if or when conditions" do
      context "when the if or when conditions are true" do
        before do
          corral do
            enable :always_on, if: -> { true }
            enable :everything, when: -> { 1 + 1 == 2 }
          end
        end

        it "enables the feature" do
          expect(enabled?(:always_on)).to be true
          expect(disabled?(:everything)).to be false
        end
      end
    end
  end
end
