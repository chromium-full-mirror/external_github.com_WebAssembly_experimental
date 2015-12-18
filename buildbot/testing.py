#! /usr/bin/env python

#   Copyright 2015 WebAssembly Community Group participants
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import os
import os.path
import subprocess
import sys


class Result:
  """Result from a single test that was run."""

  def __init__(self, test, success, output):
    self.test = test
    self.success = success
    self.output = output

  def __str__(self):
    return '%s %s%s%s' % ('SUCCEEDED' if self.success else 'FAILED',
                          self.test, '\n' if self.output else '', self.output)

  def __nonzero__(self):
    return self.success

  def __lt__(self, other):
    """Sort by test name so that the output files can be compared easily."""
    return self.test < other.test


class Tester(object):
  """Test runner."""

  def __init__(self, command_ctor, outdir, extra_params):
    """Command-line constructor accepting input and output file names."""
    assert os.path.isdir(outdir)
    self.command_ctor = command_ctor
    self.outdir = outdir
    self.extra_params = extra_params

  def __call__(self, test_file):
    """Execute a single test."""
    basename = os.path.basename(test_file)
    outname = basename + '.s'
    outfile = os.path.join(self.outdir, outname)
    # Print something simple so buildbots don't think the script is dead.
    sys.stdout.write('.')
    sys.stdout.flush()
    try:
      output = subprocess.check_output(
          self.command_ctor(test_file, outname, self.extra_params),
          stderr=subprocess.STDOUT, cwd=self.outdir)
      assert os.path.isfile(outfile), 'Missing output file %s'
      return Result(test=basename, success=True, output=output)
    except subprocess.CalledProcessError as e:
      return Result(test=basename, success=False, output=e.output)
