require 'test_helper'

class KrytenRunnerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kryten::VERSION
  end

  def setup
    @t = Kryten::Tester.new
  end

  def teardown
    Kryten::TestOutput.clear
  end

  def test_it_runs_task_once
    @t.run
    sleep 0.3
    assert_equal Kryten::TestOutput.logs,
      ["initializing", "working for 0.1", "done working"]
  end
end
