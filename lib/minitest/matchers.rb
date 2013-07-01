require "minitest/spec"

module MiniTest
  module Assertions
    ##
    # Fails unless matcher.matches?(subject) returns true
    #
    # Example:
    #
    #   def test_validations
    #     assert_must be_valid, @user
    #   end

    def assert_must matcher, subject, msg = nil
      result = matcher.matches? subject

      msg = message(msg) do
        if matcher.respond_to? :failure_message_for_should
          matcher.failure_message_for_should
        else
          matcher.failure_message
        end
      end

      assert result, msg
    end

    ##
    # Fails if matcher.matches?(subject) returns true
    #
    # Example:
    #
    #   def test_validations
    #     assert_wont be_valid, @user
    #   end

    def assert_wont matcher, subject, msg = nil
      msg = message(msg) do
        if matcher.respond_to? :failure_message_for_should_not
          matcher.failure_message_for_should_not
        else
          matcher.negative_failure_message
        end
      end

      if matcher.respond_to? :does_not_match?
        assert matcher.does_not_match?(subject), msg
      else
        refute matcher.matches?(subject), msg
      end
    end
  end

  module Expectations
    ##
    # See Minitest::Assertions#assert_must
    #
    #     user.must have_valid(:email).when("user@example.com")
    #
    # :method: must

    infect_an_assertion :assert_must, :must

    ##
    # See Minitest::Assertions#assert_wont
    #
    #     user.wont have_valid(:email).when("bad@email")
    #
    # :method: wont

    infect_an_assertion :assert_wont, :wont
  end
end

class Minitest::Spec
  ##
  # Expects that matcher matches the subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     must { have_valid(:title).when("Good") }
  #   end
  def self.must(&block)
    it { subject.must instance_eval(&block) }
  end

  ##
  # Expects that matcher does not match the subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     wont { have_valid(:title).when("Bad") }
  #   end
  def self.wont(&block)
    it { subject.wont instance_eval(&block) }
  end

  ##
  # Define a `must` expectation for implicit subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     it { must have_valid(:title).when("Good") }
  #   end

  def must(*args, &block)
    subject.must(*args, &block)
  end

  ##
  # Define a `wont` expectation for implicit subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     it { wont have_valid(:title).when("") }
  #   end

  def wont(*args, &block)
    subject.wont(*args, &block)
  end
end

class Minitest::Test
  ##
  # Defines assert_* assertion and must_* expectation for a matcher
  #
  # Example:
  #
  #   # Say you're implementing Capybara's HaveContent matcher
  #
  #   class HaveContent
  #     # ...
  #   end
  #
  #   Minitest::Test.register_matcher HaveContent, :have_content
  #
  #   class MyTest < Minitest::Test
  #     def test_index
  #       visit "/"
  #       assert_have_content page, "Hello"
  #       assert_have_selector page, :xpath, "//table/tr"
  #     end
  #   end
  #
  #   describe "my test" do
  #     test "index" do
  #       visit "/"
  #       page.must_have_content "Hello"
  #       page.must_have_selector :xpath, "//table/tr"
  #
  #       # if you set `page` to be implicit subject, following works too:
  #       must_have_content "Hello"
  #     end
  #   end
  #

  def self.register_matcher matcher, name, exp_name=name
    define_method :"assert_#{name}" do |*args|
      subject = args.shift

      x = if Symbol === matcher
            send matcher, *args
          else
            matcher.new(*args)
          end

      assert_must x, subject
    end

    Object.infect_an_assertion :"assert_#{name}", :"must_#{exp_name}", true

    define_method :"refute_#{name}" do |*args|
      subject = args.shift

      x = if Symbol === matcher
            send matcher, *args
          else
            matcher.new(*args)
          end

      assert_wont x, subject
    end

    Object.infect_an_assertion :"refute_#{name}", :"wont_#{exp_name}", true
  end
end

class Minitest::Spec # :nodoc:
  include Minitest::Matchers
end
