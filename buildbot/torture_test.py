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

import glob
import multiprocessing
import os
import os.path
import subprocess
import sys
import tempfile


CFLAGS = ['--std=gnu89', '--target=wasm32-unknown-unknown', '-S', '-O2',
          '-Wno-implicit-function-declaration', '-Wno-implicit-int']


class Result:
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
  def __init__(self, compiler):
    self.compiler = compiler
  def __call__(self, test_file):
    """Test a single source file."""
    basename = os.path.basename(test_file)
    outname = basename + '.o'
    try:
      output = subprocess.check_output(
        [self.compiler, test_file, '-o', outname] + CFLAGS,
        stderr=subprocess.STDOUT)
      assert os.path.exists(outname), 'Missing output file %s'
      # TODO(jfb) Run the program.
      os.remove(outname)
      return Result(test=basename, success=True, output=output)
    except subprocess.CalledProcessError as e:
      return Result(test=basename, success=False, output=e.output)


def run(c, cxx, testsuite):
  """Run all torture tests."""
  assert os.path.isfile(c), 'Cannot find C compiler at %s' % c
  assert os.path.isfile(cxx), 'Cannot find C++ compiler at %s' % cxx
  assert os.path.isdir(testsuite), 'Cannot find testsuite at %s' % testsuite
  # TODO(jfb) Also run other C tests, as well as C++ tests under g++.dg.
  c_torture = os.path.join(testsuite, 'gcc.c-torture', 'execute')
  assert os.path.isdir(c_torture), ('Cannot find C torture tests at %s' %
                                    c_torture)
  c_test_files = glob.glob(os.path.join(c_torture, '*c'))
  pool = multiprocessing.Pool()
  results = sorted(pool.map(Tester(c), c_test_files))
  failure_count = sum([1 for result in results if result])
  for result in results:
    print result
  print 'Ran %s tests.' % len(results)
  print 'Got %s failures:' % failure_count
  print '\n'.join('\t' + result.test for result in results if not result)
  # TODO(jfb) Figure out which failures are expected.
  return failure_count


def getargs():
  import argparse
  parser = argparse.ArgumentParser(description='Run GCC torture tests.')
  parser.add_argument('--c', type=str, required=True,
                      help='C compiler path')
  parser.add_argument('--cxx', type=str, required=True,
                      help='C++ compiler path')
  parser.add_argument('--testsuite', type=str, required=True,
                      help='GCC testsuite tests path')
  return parser.parse_args()


if __name__ == '__main__':
  args = getargs()
  sys.exit(run(args.c, args.cxx, args.testsuite))
