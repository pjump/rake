#!/usr/bin/env ruby

require 'test/unit'
require 'fileutils'
require 'rake'
require 'test/filecreation'

######################################################################
class TestFileCreationTask < Test::Unit::TestCase
  include FileCreation

  DUMMY_DIR = 'testdata/dummy_dir'

  def setup
    Task.clear
  end

  def teardown
    FileUtils.rm_rf DUMMY_DIR
  end

  def test_file_needed
    create_dir DUMMY_DIR
    fc_task = Task[DUMMY_DIR]
    assert_equal DUMMY_DIR, fc_task.name
    FileUtils.rm_rf fc_task.name
    assert fc_task.needed?, "file should be needed"
    FileUtils.mkdir fc_task.name
    assert_equal nil, fc_task.prerequisites.collect{|n| Task[n].timestamp}.max
    assert ! fc_task.needed?, "file should not be needed"
  end

  def test_directory
    directory DUMMY_DIR
    fc_task = Task[DUMMY_DIR]
    assert_equal DUMMY_DIR, fc_task.name
    assert FileCreationTask === fc_task
  end

  def test_no_retriggers_on_filecreate_task
    create_timed_files(OLDFILE, NEWFILE)
    t1 = FileCreationTask.lookup(OLDFILE).enhance([NEWFILE])
    t2 = FileCreationTask.lookup(NEWFILE)
    assert ! t2.needed?, "Should not need to build new file"
    assert ! t1.needed?, "Should not need to rebuild old file because of new"
  end

  def test_no_retriggers_on_file_task
    create_timed_files(OLDFILE, NEWFILE)
    t1 = FileTask.lookup(OLDFILE).enhance([NEWFILE])
    t2 = FileCreationTask.lookup(NEWFILE)
    assert ! t2.needed?, "Should not need to build new file"
    assert ! t1.needed?, "Should not need to rebuild old file because of new"
  end
end
