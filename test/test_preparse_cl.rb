# -*- coding: utf-8 -*-
require File.expand_path('../helper', __FILE__)
require 'rake/preparse_cl'

class TestRakePreparseCli < Rake::TestCase
  include Rake::CLI

  def test_simple_cli_preparse
    args = %w[ task1 [ --foo bar foobar --foo --fds ] --bar foo --fds  task2 [ foo bar ] ]
    expected_args = ["task1", "--bar", "foo", "--fds", "task2"]
    expected_hash = {"task1"=>["--foo", "bar", "foobar", "--foo", "--fds"], "task2"=>["foo", "bar"]}
    actual_hash = preparse_argv!(args)
    assert_equal expected_hash, actual_hash
    assert_equal expected_args, args
  end

  def test_cli_preparse_with_basic_args
    args = %w[ task1[foo,bar] [ --foo bar foobar --foo --fds ] --bar foo --fds  task2[baz] [ foo bar ] ]
    expected_args = ["task1[foo,bar]", "--bar", "foo", "--fds", "task2[baz]"]
    expected_hash = {"task1"=>["--foo", "bar", "foobar", "--foo", "--fds"], "task2"=>["foo", "bar"]}
    actual_hash = preparse_argv!(args)
    assert_equal expected_hash, actual_hash
    assert_equal expected_args, args
  end

end

