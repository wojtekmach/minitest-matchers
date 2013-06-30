# minitest-matchers

http://github.com/wojtekmach/minitest-matchers

[![Build Status](https://secure.travis-ci.org/wojtekmach/minitest-matchers.png?branch=master)](http://travis-ci.org/wojtekmach/minitest-matchers)

## Warning

Don't use it! Writing simple assertions (and Minitest way of transforming them to expectations) is almost always a better idea anyway. Work with your favourite library authors to start with assertions and add matchers for convenience and not the other way around. Keep it simple.

## Description

minitest-matchers adds support for RSpec/Shoulda-style matchers to
minitest/unit and minitest/spec.

More information about matchers can be found here:

* https://www.relishapp.com/rspec/rspec-expectations
* http://railscasts.com/episodes/157-rspec-matchers-macros

For use with Rails check out (ValidAttribute + Capybara):

* https://github.com/wojtekmach/minitest-rails-example

## Features/Problems

* Enables you to use existing matcher classes from projects like
  valid\_attribute and capybara
* Can be used both in MiniTest::Unit::TestCase & MiniTest::Spec

## Synopsis

see example matcher: [matcher.rb](https://github.com/bcardarella/valid_attribute/blob/master/lib/valid_attribute/matcher.rb)

```ruby
require "minitest/matchers"
require "minitest/autorun"
require "valid_attribute"
require "active_model"

class Post
  include ActiveModel::Validations
  attr_accessor :title
  validates :title, :presence => true, :length => 4..20
end

# Using minitest/unit

class PostTest < MiniTest::Unit::TestCase
  include ValidAttribute::Method

  def test_validations
    post = Post.new

    assert_must have_valid(:title).when("Good"), post
    assert_wont have_valid(:title).when(""), post
  end
end

# Using minitest/spec

describe Post do
  include ValidAttribute::Method

  it "should have validations" do
    post = Post.new

    post.must have_valid(:title).when("Good")
    post.wont have_valid(:title).when("")
  end
end

# Using minitest/spec with subject

describe Post do
  subject { Post.new }

  it { must have_valid(:title).when("Hello") }
  it { wont have_valid(:title).when("", nil, "Bad") }
end

# or

describe Post do
  subject { Post.new }

  must { have_valid(:title).when("Hello") }
  wont { have_valid(:title).when("", nil, "Bad") }
end
```

You can also register matcher so that it works similar to built-in
assertions and expectations. Note subject must be the first argument in assertion.

```ruby
MiniTest::Unit::TestCase.register_matcher HaveContent, :have_content
MiniTest::Unit::TestCase.register_matcher :have_selector, :have_selector

assert_have_content page, "Hello"
assert_have_selector page, :xpath, "//table/tr"

page.must_have_content "Hello"
page.must_have_selector :xpath, "//table/tr"
```

## Requirements

* `minitest >= 2.7.0`

## Install

```
gem install minitest-matchers
```

or add to Gemfile:

```ruby
group :test do
  gem 'minitest-matchers'
end
```

## License

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb, Wojciech Mach

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
