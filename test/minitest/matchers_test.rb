gem "minitest"
require "minitest/autorun"
require "minitest/matchers"

class BadMatcher; end

class KindOfMatcher
  def initialize klass
    @klass = klass
  end

  def description
    "be kind of #{@klass}"
  end

  def matches? subject
    subject.kind_of? @klass
  end

  def failure_message_for_should
    "expected to " + description
  end

  def failure_message_for_should_not
    "expected not to " + description
  end
end

def be_kind_of klass
  KindOfMatcher.new klass
end

describe Minitest::Test do
  it "needs to verify assert_must" do
    assert_must(be_kind_of(Array), []).must_equal true
    proc { assert_must be_kind_of(String), [] }.must_raise Minitest::Assertion
  end

  it "needs to verify assert_wont" do
    assert_wont(be_kind_of(String), []).must_equal false
    proc { assert_wont be_kind_of(Array), [] }.must_raise Minitest::Assertion
  end
end

describe Minitest::Test, :register_matcher do
  Minitest::Test.register_matcher KindOfMatcher, :my_kind_of, :be_my_kind_of
  Minitest::Test.register_matcher :be_kind_of, :meth_kind_of, :meth_my_kind_of

  it "needs to verify assert_<matcher>" do
    assert_my_kind_of("", String).must_equal true
    proc { assert_my_kind_of [], String }.must_raise Minitest::Assertion
  end

  it "needs to verify must_<matcher>" do
    "".must_be_my_kind_of(String).must_equal true
    proc { [].must_be_my_kind_of String }.must_raise Minitest::Assertion
  end

  it "needs to verify refute_<matcher>" do
    refute_my_kind_of("", Array).must_equal false
    proc { refute_my_kind_of [], Array }.must_raise Minitest::Assertion
  end

  it "needs to verify wont<matcher>" do
    "".wont_be_my_kind_of(Array).must_equal false
    proc { [].wont_be_my_kind_of(Array) }.must_raise Minitest::Assertion
  end

  it "accepts method as matcher" do
    assert_meth_kind_of("", String).must_equal true
    proc { assert_meth_kind_of [], String }.must_raise Minitest::Assertion
    refute_meth_kind_of("", Array).must_equal false
    proc { refute_my_kind_of [], Array }.must_raise Minitest::Assertion
  end
end

describe Minitest::Spec do
  it "needs to verify must" do
    [].must(be_kind_of(Array)).must_equal true
    proc { [].must be_kind_of(String) }.must_raise Minitest::Assertion
  end

  it "needs to verify wont" do
    [].wont(be_kind_of(String)).must_equal false
    proc { [].wont be_kind_of(Array) }.must_raise Minitest::Assertion
  end

  describe "implicit subject" do
    subject { [1, 2, 3] }

    must { be_kind_of(Array) }
    wont { be_kind_of(String) }

    it "verifies must" do
      must be_kind_of(Array)
      proc { must be_kind_of(String) }.must_raise Minitest::Assertion
    end

    it "verifies wont" do
      wont be_kind_of(String)
      proc { wont be_kind_of(Array) }.must_raise Minitest::Assertion
    end
  end
end
