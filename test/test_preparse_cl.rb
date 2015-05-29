# -*- coding: utf-8 -*-
require File.expand_path('../helper', __FILE__)
require 'rake/preparse_cl'

class TestRakePreparseCli < Rake::TestCase
  include Rake::CLI

  def test_cli_preparse
    args = %w[ task1 [ --foo bar foobar --foo --fds ] --bar foo --fds  task2 [ foo bar ] ]
    expected_args = ["task1", "--bar", "foo", "--fds", "task2"]
    expected_hash = {"task1"=>["--foo", "bar", "foobar", "--foo", "--fds"], "task2"=>["foo", "bar"]}
    actual_hash = preparse_argv!(args)
    assert_equal expected_hash, actual_hash
    assert_equal expected_args, args
  end

end

