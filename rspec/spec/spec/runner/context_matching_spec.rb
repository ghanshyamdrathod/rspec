require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    context "ContextMatching" do

      setup do
        @formatter = Spec::Mocks::Mock.new("formatter")
        @context = Context.new("context") {}
        @context_eval = @context.instance_eval { @context_eval_module }
        @matcher = Spec::Mocks::Mock.new("matcher")
      end

      specify "run all specs when spec is not specified" do
        @context_eval.specify("spec1") {}
        @context_eval.specify("spec2") {}
        @context.run_single_spec("context")
        @context.number_of_specs.should_equal(2)
      end

      specify "should only run specified specs when specified" do
        @context_eval.specify("spec1") {}
        @context_eval.specify("spec2") {}
        @context.run_single_spec("context spec1")
        @context.number_of_specs.should_equal(1)
      end

      specify "should use spec matcher" do
        @matcher.should_receive(:matches?).with("submitted spec")
        @context_eval.specify("submitted spec") {}
        (not @context.matches?("context with spec", @matcher)).should_be(true)
      end
    end
  end
end