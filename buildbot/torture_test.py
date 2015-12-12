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
  def __init__(self, c, cxx, out):
    self.c = c
    self.cxx = cxx
    self.out = out
  def __call__(self, test_file):
    """Test a single source file."""
    basename = os.path.basename(test_file)
    outname = basename + '.s'
    outfile = os.path.join(self.out, outname)
    # Print something simple so buildbots don't think the script is dead.
    sys.stdout.write('.')
    sys.stdout.flush()
    try:
      output = subprocess.check_output(
        [self.c, test_file, '-o', outname] + CFLAGS,
        stderr=subprocess.STDOUT, cwd=self.out)
      assert os.path.exists(outfile), 'Missing output file %s'
      return Result(test=basename, success=True, output=output)
    except subprocess.CalledProcessError as e:
      return Result(test=basename, success=False, output=e.output)


def get_expected_failures(fails):
  """One failure per line, some whitespace, Python-style comments."""
  assert os.path.isfile(fails), 'Cannot find known failures at %s' % fails
  res = []
  with open(fails, 'r') as fails_file:
    res = fails_file.readlines()
  return sorted([r for r in [r.split('#')[0].strip() for r in res] if len(r)])


def run(c, cxx, testsuite, fails, out):
  """Run all torture tests."""
  assert os.path.isfile(c), 'Cannot find C compiler at %s' % c
  assert os.path.isfile(cxx), 'Cannot find C++ compiler at %s' % cxx
  assert os.path.isdir(testsuite), 'Cannot find testsuite at %s' % testsuite
  # TODO(jfb) Also run other C tests, as well as C++ tests under g++.dg.
  c_torture = os.path.join(testsuite, 'gcc.c-torture', 'execute')
  expected_failures = get_expected_failures(fails)
  assert os.path.isdir(c_torture), ('Cannot find C torture tests at %s' %
                                    c_torture)
  assert os.path.isdir(out)
  c_test_files = glob.glob(os.path.join(c_torture, '*c'))
  pool = multiprocessing.Pool()
  sys.stdout.write('Running')
  results = sorted(pool.map(Tester(c=c, cxx=cxx, out=out), c_test_files))
  sys.stdout.write('\nDone.')
  r_successes = [r for r in results if r]
  r_failures = [r for r in results if not r]
  r_expected_failures = [t for t in r_failures
                         if t.test in expected_failures]
  r_unexpected_failures = [t for t in r_failures
                           if t.test not in expected_failures]
  r_unexpected_successes = [t for t in r_successes
                            if t.test in expected_failures]
  sys.stdout.write('Results:\n')
  for result in results:
    sys.stdout.write(str(result) + '\n\n')
  if r_expected_failures:
    sys.stdout.write('Expected failures:\n')
    for f in r_expected_failures:
      sys.stdout.write('\t%s\n' % f.test)
  if r_unexpected_failures:
    sys.stdout.write('Unexpected failures:\n')
    for f in r_unexpected_failures:
      sys.stdout.write('\t%s\n' % f.test)
  if r_unexpected_successes:
    sys.stdout.write('Unexpected successes:\n')
    for f in r_unexpected_successes:
      sys.stdout.write('\t%s\n' % f.test)
  sys.stdout.write(
    '\n'.join(['\n',
               'Ran %s tests.' % len(results),
               'Got %s successes.' % len(r_successes),
               'Got %s failures.' % len(r_failures),
               'Expected %s failures.' % len(expected_failures),
               'Got %s expected failures.' % len(r_expected_failures),
               'Got %s unexpected failures.' % len(r_unexpected_failures),
               'Got %s unexpected successes.' % len(r_unexpected_successes),
               '\n']))
  return len(r_unexpected_failures) + len(r_unexpected_successes)


def getargs():
  import argparse
  parser = argparse.ArgumentParser(description='Run GCC torture tests.')
  parser.add_argument('--c', type=str, required=True,
                      help='C compiler path')
  parser.add_argument('--cxx', type=str, required=True,
                      help='C++ compiler path')
  parser.add_argument('--testsuite', type=str, required=True,
                      help='GCC testsuite tests path')
  parser.add_argument('--fails', type=str, required=True,
                      help='Expected failures')
  parser.add_argument('--out', type=str, required=True,
                      help='Output directory')
  return parser.parse_args()


if __name__ == '__main__':
  args = getargs()
  sys.exit(run(args.c, args.cxx, args.testsuite, args.fails, args.out))
